/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_init


Description:
    To set up the aircraft for full ai crew

Parameters:
    Heli: Object - The helicopter to modify

Returns:
    Nothing

Examples:
    [_heli] call fza_aiCrew_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_aiCrewInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aiCrewInitialised", true, true];

    //Gets AI rocketpods to work & aim accurately
    _heli animateSource["pylon1", 0.5]; 
    _heli animateSource["pylon2", 0.5]; 
    _heli animateSource["pylon3", 0.5]; 
    _heli animateSource["pylon4", 0.5];
};