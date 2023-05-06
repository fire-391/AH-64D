params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

private _varMapping = createHashMapFromArray
    [ ["LRFD", "fza_ah64_laserLRFDCode"]
    , ["LST" , "fza_ah64_laserLSTCode"]
    ];

private _varName = _varMapping get (_persistState get "set");

#define SET_CHANNEL_CODE(code) _heli setVariable [_varName, code, true];

switch (_control) do {
    case "t1": {
        [_heli, _mpdIndex, "CHAN"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t2": {
        switch (_persistState get "set") do {
            case "LRFD": {
                _persistState set ["set", "LST"];
            };
            case "LST": {
                _persistState set ["set", "LRFD"];
            };
        };
    };
    case "t4": {
        [_heli, _mpdIndex, "WPN"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t5": {
        [_heli, _mpdIndex, "FREQ"] call fza_mpd_fnc_setCurrentPage;
    };

    // Missile channel selections
    case "l1": { SET_CHANNEL_CODE("A") };
    case "l2": { SET_CHANNEL_CODE("B") };
    case "l3": { SET_CHANNEL_CODE("C") };
    case "l4": { SET_CHANNEL_CODE("D") };
    case "l5": { SET_CHANNEL_CODE("E") };
    case "l6": { SET_CHANNEL_CODE("F") };
    case "b2": { SET_CHANNEL_CODE("G") };
    case "b3": { SET_CHANNEL_CODE("H") };
    case "b4": { SET_CHANNEL_CODE("J") };
    case "b5": { SET_CHANNEL_CODE("K") };
    case "r6": { SET_CHANNEL_CODE("L") };
    case "r5": { SET_CHANNEL_CODE("M") };
    case "r4": { SET_CHANNEL_CODE("N") };
    case "r3": { SET_CHANNEL_CODE("P") };
    case "r2": { SET_CHANNEL_CODE("Q") };
    case "r1": { SET_CHANNEL_CODE("R") };

    case "b1": {
        [_heli, _mpdIndex, "WPN"] call fza_mpd_fnc_setCurrentPage;
    };
}