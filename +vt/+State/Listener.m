classdef Listener < vt.Listener
	properties
		listenerHandle
	end
	
	methods
		function [] = registerAllMethodsToState(this, state)
			this.listenerHandle = addlistener( ...
				state, ...
				'StateChange', ...
				@(source, eventdata) update(this, eventdata.data.propertyName, eventdata.data.state) ...
			);
		end
		
		function [] = update(this, propertyName, state)
			p = inputParser;
			p.StructExpand = false;
			p.addRequired('this',  @(this) isa(this, 'vt.State.Listener'));
			p.addRequired('propertyName', @ischar);
			p.addRequired('state', @isstruct);
			parse(p, this, propertyName, state);
			
			% Prevent trying to call handles that have been deleted
			try
                if vt.Config.isOldMatlabVersion()
                    if(isa(this, 'vt.Component') && ~ishandle(this.handle))
                        disp(['Avoiding deleted handle ' class(this)]);
                        return;
                    end
                else
                    if(isa(this, 'vt.Component') && ~(isvalid(this.handle) && ishandle(this.handle)))
                        disp(['Avoiding deleted handle ' class(this)]);
                        return;
                    end
                end
			catch excp
				this.log.exception(excp);
			end
			
			method = this.property2method(p.Results.propertyName);
			if this.isMethod(method)
				this.(method)(p.Results.state);
			end
		end
		
		function b = isCharOrCellStr(~, propertyName)
			b = (ischar(propertyName) || iscellstr(propertyName));
		end
		
		function method = property2method(this, propertyName)
			p = vt.InputParser;
			p.addRequired('propertyName', @ischar);
			p.parse(propertyName);
			
			circumfixed_propertyName = ['on_' p.Results.propertyName '_change'];
			method = this.underscore2camelCase(circumfixed_propertyName);
		end
		
		function propertyList = getProperties(this, state)
			methodList = methods(this);
			propertyList = {};
			for iMethod = 1:numel(methodList)
				m = methodList{iMethod};
				p = this.method2property(m);
				if(~isempty(p) && this.isStateProperty(p, state))
					propertyList = [propertyList, p]; %#ok<AGROW>
				end
			end
		end
		
		function propertyName = method2property(~, method)
			propertyName = [];
			if(strcmp(method(1:2), 'on') && strcmp(method(end-5:end), 'Change'))
				propertyName = [lower(method(3)) method(4:end-6)];
			end
		end
		
		function tf = isStateProperty(~, propertyName, state)
			tf = ismember(propertyName, properties(state));
		end
		
		function [] = delete(this)
			if(isvalid(this.listenerHandle))
				if(this.listenerHandle.Enabled)
					this.listenerHandle.Enabled = false;
				end
				delete(this.listenerHandle);
			end
		end
		
	end
	
end

