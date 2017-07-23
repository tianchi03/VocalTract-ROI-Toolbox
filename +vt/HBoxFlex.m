classdef HBoxFlex < vt.LayoutComponent
	properties
	end
	
	methods
		function this = HBoxFlex(parent, varargin)
			this@vt.LayoutComponent(parent, varargin{:});
		end
	end
	
	methods (Access = protected);
		function [] = construct(this, parent)
			p = vt.InputParser;
			p.addRequired('this', @(this) isa(this, 'vt.HBoxFlex'));
			p.addParent();
			parse(p, this, parent);
			
			this.handle = uix.HBoxFlex( ...
				'Parent', parent.handle ...
			);
		end
	end
	
end

