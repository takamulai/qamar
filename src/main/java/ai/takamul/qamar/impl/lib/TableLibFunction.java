package ai.takamul.qamar.impl.lib;

import ai.takamul.qamar.impl.LuaValue;

class TableLibFunction extends LibFunction {
	public LuaValue call() {
		return argerror(1, "table expected, got no value");
	}
}
