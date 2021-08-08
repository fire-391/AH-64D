/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusPowerLever

Description:

Parameters:

Returns:

Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_state"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

private _engPwrLeverAnimName = format["plt_eng%1_throttle", _engNum + 1]; 

if (_state == "OFF") then {
	_heli animateSource[_engPwrLeverAnimName, 0];
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	//HeliSim
	//[_heli, _engNum, 0.0] call bmk_fnc_engineSetThrottle;
};

if (_state == "IDLE") then {
	_heli animateSource[_engPwrLeverAnimName, 0.25];
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	//HeliSim
	//[_heli, _engNum, 0.25] call bmk_fnc_engineSetThrottle;
};

if (_state == "FLY") then {
	//0.063 sets the power levers to fly in 16 seconds
	_heli animateSource[_engPwrLeverAnimName, 1, 0.25];
	[_heli, "fza_sfmplus_engPowerLeverState", _engNum, _state] call fza_sfmplus_fnc_setArrayVariable;

	//HeliSim
	//[_heli, _engNum, 1.0] call bmk_fnc_engineSetThrottle;
};
