/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusStartSwitch

Description:

Parameters:

Returns:


Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_state"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

//private _otherEngineNum = if (_engNum == 0) then { 1 } else { 0 };

private _engStartSwitch = format["plt_eng%1_start", _engNum + 1];

//If the start switch is in the off position, move it to the start position
if (_state == "START") then {
	_heli animateSource[_engStartSwitch, 1];
	[_heli, "fza_ah64_engStartSwitchState", _engNum, _state] call fza_fnc_sfmplusSetArrayVariable;
};

if (_state == "OFF") then {
	_heli animateSource[_engStartSwitch, 0];
}

