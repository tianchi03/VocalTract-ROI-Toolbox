classdef Radius < vt.Component.TextBox & vt.State.Listener & vt.Action.Dispatcher
	properties
		actionType = @vt.Action.ChangeRegionRadius;
		maxRadius
	end
	
	methods
		function this = Radius(parent)
			p = vt.InputParser();
			p.addParent();
			p.parse(parent);
			
			this@vt.Component.TextBox(parent);
			this.setParameters('String', '3');
			this.data = '3';
			
			this.setCallback();
		end
		
		function [] = onIsEditingChange(this, state)
			switch(state.isEditing)
				case 'region'
					this.setParameters('Enable', 'on');
				otherwise
					this.setParameters('Enable', 'off');
			end
		end
		
		function [] = onCurrentRegionChange(this, state)
			this.maxRadius = round(min(state.video.height, state.video.width) / 2);
			this.setParameters('String', num2str(state.currentRegion.radius));
		end
		
		function [] = dispatchAction(this, ~, ~)
			str = this.getParameter('String');
			num = str2double(str);
			try
				assert(~isempty(num) && ~isnan(num));
			catch
				this.setParameters('String', this.data);
				excp = MException('InvalidInput:RegionRadius', 'Radius must be numerical.');
				this.log.exception(excp);
			end
			
% 			validatedNum = [];
			if(num < 1)
				validatedNum = 1;
			elseif(num > this.maxRadius)
				validatedNum = this.maxRadius;
			else
				validatedNum = num;
			end
			if(validatedNum ~= num)
				this.setParameters('String', num2str(validatedNum));
			end
			this.data = str;
			this.action.dispatch(validatedNum);
		end
	end
	
end