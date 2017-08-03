classdef (Abstract) Component < vt.Root
	
	properties
		handle
	end
	
	methods		
		function [] = setParameters(this, varargin)
			p = inputParser;
			p.KeepUnmatched = true;
			p.addRequired('this', @(this) isa(this, 'vt.Component'));
			parse(p, this, varargin{:});
			
			params = fieldnames(p.Unmatched);

			for i = 1:numel(params)
				set(this.handle, params{i}, p.Unmatched.(params{i}));
			end
			
% 			addlistener( ...
% 				this.handle, ...
% 				'BeingDeleted', ...
% 				'PostSet', ...
% 				@(source, eventdata) showDeletion(this) ...
% 			);
		end
		
		function value = getParameter(this, param)
			p = inputParser;
			p.addRequired('param', @ischar);
			parse(p, param);
			
			value = get(this.handle, param);
		end
		
		function [] = showDeletion(this)
			disp('Deleting handle!');
		end
	end
		
	methods (Access = ?vt.Action.Dispatcher)
		function [] = setCallback(this, varargin)
			p = inputParser;
			p.addRequired('this', @(this) isa(this, 'vt.Action.Dispatcher'));
			p.addOptional('callbackName', 'Callback', @ischar);
			p.parse(this, varargin{:});

			set( ...
				this.handle, ...
				p.Results.callbackName, ...
				@(source, eventdata) dispatchAction(this, source, eventdata) ...
			);
		end
	end
	
end

