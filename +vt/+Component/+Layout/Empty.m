classdef Empty < vt.Component.Layout
	methods
		function this = Empty(parent, varargin)
			this@vt.Component.Layout(parent, varargin{:});
		end
	end
	
	methods (Access = protected)
		function [] = construct(this, parent)
			p = vt.InputParser;
			p.addParent();
			parse(p, parent);
			
			if ( this.isOldMatlabVersion() )
				% Use the old version of the GUI Layout Toolbox
				this.handle = guilayouttoolbox.old.layout.uiextras.Empty( ...
					'Parent', p.Results.parent.handle ...
				);
			else
				% Use the new version of the GUI Layout Toolbox
				this.handle = guilayouttoolbox.new.layout.uix.Empty( ...
					'Parent', p.Results.parent.handle ...
				);
			end
		end
	end
end

