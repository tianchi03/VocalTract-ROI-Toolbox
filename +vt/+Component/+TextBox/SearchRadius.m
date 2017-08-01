classdef SearchRadius < vt.Component.TextBox & vt.State.Listener
	properties
		actionType = @vt.Action.ChangeSearchRadius;
	end
	
	methods
		function this = SearchRadius(parent)
			p = vt.InputParser();
			p.addParent();
			p.parse(parent);
			
			this@vt.Component.TextBox(parent);
			this.setParameters('Enable', 'off');
			
% 			this.setCallback();
		end
		
		function this = onIsEditingChange(this, state)
			if(strcmp(state.isEditing, 'region'))
				this.setParameters('Enable', 'on');
			end
		end
	end
	
end