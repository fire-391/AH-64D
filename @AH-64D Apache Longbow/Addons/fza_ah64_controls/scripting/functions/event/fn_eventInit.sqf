/* ----------------------------------------------------------------------------
Function: fza_fnc_eventInit

Description:
    Master init event handler

    Handles variable initialisation, and continues running to ensure weapon textures are kept up to date

    Must be run in a scheduled environment (spawn)

Parameters:
    _heli - the helicopter to initialise

Returns:
	Nothing

Examples:
    [_heli] spawn fza_fnc_eventInit

Author:
	unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\selections.h"
params["_heli"];

if (!(isNil "fza_ah64_noinit")) exitwith {};
_heli addAction ["<t color='#ff0000'>Weapons inhibited</t>", {}, [], -10, false, false, "DefaultAction", "count (_target getVariable ""fza_ah64_weaponInhibited"") != 0"];

if (!(_heli getVariable ["fza_ah64_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftInitialised", true, true];
    _heli selectweapon "fza_ma_safe";
    _heli animateSource ["pdoor", 0];
    _heli animateSource ["gdoor", 0];
    _heli animateSource ["plt_rtrbrake", 1];
    _heli animateSource ["plt_firesw", 0.5];
    _heli animateSource ["cpg_firesw", 0.5];
    _heli animateSource ["tads_stow", 1];
    _heli setVariable ["fza_ah64_estarted", false, true];
    _heli setVariable ["fza_ah64_agmode", 0, true];
    _heli setVariable ["fza_ah64_pfzs", [[],[],[],[],[],[],[],[]], true];
    _heli setVariable ["fza_ah64_pfz_count", 0, true];
    _heli setVariable ["fza_ah64_curwpnum", 0, true];
    _heli setVariable ["fza_ah64_waypointdata", [getPos _heli], true];
    _heli setVariable ["fza_ah64_sight_plt", 1, true];
    _heli setVariable ["fza_ah64_sight_cpg", 1, true];
    _heli setVariable ["fza_ah64_hmdfsmode", "trans", true];
    _heli setVariable ["fza_ah64_ltype", "TopDown", true];
    _heli setVariable ["fza_ah64_shotat_list", [], true];
    _heli setVariable ["fza_ah64_shotmissile_list", [], true];
    _heli setVariable ["fza_ah64_tsdsort", 0, true];
    _heli setVariable ["fza_ah64_currentLase", objNull, true];
    _heli setVariable ["fza_ah64_currentSkippedLases", [], true];
    _heli setVariable ["fza_ah64_irjamfail", false, true];
    _heli setVariable ["fza_ah64_rfjamfail", false, true];
    _heli setVariable ["fza_ah64_apu_fire", false, true];
    _heli setVariable ["fza_ah64_e1_fire", false, true];
    _heli setVariable ["fza_ah64_e2_fire", false, true];
    _heli setVariable ["fza_ah64_firepdisch", false, true];
    _heli setVariable ["fza_ah64_firerdisch", false, true];
    _heli setVariable ["fza_ah64_irjstate", 0, true];
    _heli setVariable ["fza_ah64_rfjstate", 0, true];
    _heli setVariable ["fza_ah64_irjon", 0, true];
    _heli setVariable ["fza_ah64_rfjon", 0, true];
    _heli setVariable["fza_ah64_engineStates", [
        ["OFF", 0],
        ["OFF", 0]
    ], true];
    _heli setVariable ["fza_ah64_tadsLocked", objNull, true];
};
_heli setVariable ["fza_ah64_weaponInhibited", ""];
_heli setVariable ["fza_ah64_aseautopage", 0];
_heli setVariable ["fza_ah64_mpdPage", ["OFF", "OFF"]];
_heli setVariable ["fza_ah64_mpdCurrPage", ["OFF", "OFF"]];
_heli setVariable ["fza_ah64_burst_limit", 10];
_heli setVariable ["fza_ah64_fcrcscope", false];
_heli setVariable ["fza_ah64_ihadssoff", 1];
_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
_heli setVariable ["fza_ah64_ihadss_pnvs_day", true];
_heli setVariable ["fza_ah64_monocleinbox", true];
_heli setVariable ["fza_ah64_mpdbrightness", 1];
_heli setVariable ["fza_ah64_rangesetting", 0.001]; //1km
_heli setVariable ["fza_ah64_rocketsalvo", 1];
_heli setVariable ["fza_ah64_tsdmode", "nav"];
_heli setVariable ["fza_ah64_fire1arm", 0];
_heli setVariable ["fza_ah64_fire2arm", 0];
_heli setVariable ["fza_ah64_fireapuarm", 0];

//SFM+
_heli setVariable ["fza_ah64_emptyMassFCR",    6609]; //kg
_heli setVariable ["fza_ah64_emptyMassNonFCR", 6314]; //kg

_heli setVariable ["fza_ah64_stabPos", [0.0, -7.207, -0.50]];
_heli setVariable ["fza_ah64_stabWidth", 3.22];  //m
_heli setVariable ["fza_ah64_stabLength", 1.07]; //m

_heli setVariable ["fza_ah64_maxFwdFuelMass", 473];	    //1043lbs in kg
//_heli setVariable ["fza_ah64_maxCtrFuelMass", 300];	//663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_ah64_maxAftFuelMass", 669]; 	//1474lbs in kg
//_heli setVariable ["fza_ah64_maxExtFuelMass", 690];     //1541lbs in kg, not yet implemented, 230gal external tank

[_heli] call fza_fnc_sfmplusSetFuel;
[_heli] call fza_fnc_sfmplusSetMass;

_heli setVariable ["fza_ah64_totRtrDmg",     0];
_heli setVariable ["fza_ah64_dmgTimerCont",  0];
_heli setVariable ["fza_ah64_dmgTimerTrans", 0];
[_heli] call fza_fnc_sfmplusEngineVariables;

if (player in _heli && !is3den && {fza_ah64_showPopup && !fza_ah64_introShownThisScenario}) then {
    createDialog "RscFzaDisplayWelcome";
};

//Fixes pylons that went onto the wrong turret (pilot, rather than gunner)
if (local _heli) then { 
    { 
        _x params ["_pylId", "", "_pylTurr", "_pylMag", "_pylAmmo"]; 
        if (_pylTurr isNotEqualTo [0]) then { 
            _wep = configFile >> "CfgMagazines" >> _pylMag >> "pylonWeapon";
            if (isText _wep) then {
                [[_heli, getText _wep, _pylTurr], { 
                    params["_heli", "_weapon", "_turret"]; 
                    
                    _heli removeWeaponTurret [_weapon, _turret] 
                }] remoteExec ["call", [driver _heli, _heli] select (isNull driver _heli)];
            };
            _heli setPylonLoadout [_pylId, _pylMag, true, [0]]; 
            _heli setAmmoOnPylon [_pylId, _pylAmmo]; 
        }; 
    } foreach getAllPylonsInfo _heli; 
};

//DEFAULT WEIGHT 

if ((weightRTD _heli select 3) == 0) then {
    if (_heli animationPhase "fcr_enable" == 1) then {
        _heli setCustomWeightRTD 295;
    };
};
_heli enableVehicleSensor ["ActiveRadarSensorComponent", _heli animationPhase "fcr_enable" == 1];
_heli setCustomWeightRTD ([0, 295] select (_heli animationPhase "fcr_enable" == 1));

if !(isMultiplayer) then {
    _blades = [_heli] execvm "\fza_ah64_controls\scripting\singleplayer\bladerot.sqf";
};

while {
    alive _heli
}
do {
    if ((!isNull (_heli getVariable["fza_ah64_floodlight_plt", objNull])) && _heli animationphase "plt_batt" < 0.5) then {

        _heli setobjecttexture [SEL_IN_BACKLIGHT, ""];
        _heli setobjecttexture [SEL_IN_BACKLIGHT2, ""];

        deleteVehicle(_heli getVariable["fza_ah64_floodlight_plt", objnull]);
        deleteVehicle(_heli getVariable["fza_ah64_floodlight_cpg", objnull]);
    };
    _magsp = _heli magazinesturret[-1];

    if (local _heli) then {
        _tadsShouldBeStowed = _heli animationphase "plt_apu" < 1 && !isEngineOn _heli;
        
        if (_tadsShouldBeStowed && _heli animationPhase "tads_stow" == 0) then {
            _heli animateSource ["tads_stow", 1];
        };
        if (!_tadsShouldBeStowed && _heli animationPhase "tads_stow" == 1) then {
            _heli animateSource ["tads_stow", 0];
        };
    };
    sleep 0.03;
};
