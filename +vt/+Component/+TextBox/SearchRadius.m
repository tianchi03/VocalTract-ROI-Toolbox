classdef SearchRadius < vt.Component.TextBox %& vt.State.Listener
	properties
		actionType = @vt.Action.ChangeSearchRadius;
	end
	
	methods
		function this = SearchRadius(parent, varargin)
			p = vt.InputParser();
			p.KeepUnmatched = true;
			p.addParent();
			p.parse(parent, varargin{:});
			
			this@vt.Component.TextBox(parent, varargin{:});
			
% 			this.setCallback();
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
			this.maxRadius = round(min(state.video.height, state.video.width) / 3);
			this.setParameters('String', num2str(state.currentRegion.searchRadius));
			this.data = num2str(state.currentRegion.searchRadius);
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
			if(num < 0)
				validatedNum = 0;
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