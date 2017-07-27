classdef HButtonBox < vt.Component.Layout
	methods
		function this = HButtonBox(parent, varargin)
			this@vt.Component.Layout(parent, varargin{:});
		end
	end
	
	methods (Access = protected)
		function [] = construct(this, parent)
			p = vt.InputParser;
			p.addRequired('this', @(this) isa(this, 'vt.Component.Layout.HButtonBox'));
			p.addParent();
			parse(p, this, parent);
			
			this.handle = uix.HButtonBox( ...
				'Parent', parent.handle ...
			);
		end
	end
	
end

