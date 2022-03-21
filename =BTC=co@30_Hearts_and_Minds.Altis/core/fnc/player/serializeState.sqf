
/* ----------------------------------------------------------------------------
Function: btc_player_fnc_serializeState

Description:
    Serialize player slot.

Parameters:
    _unit - Unit. [Object]

Returns:

Examples:
    (begin example)
        [allPlayers#0] call btc_player_fnc_serializeState;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_unit", objNull, [objNull]]
];

private _data = [
    getPosASL _unit,
    getDir _unit,
    getUnitLoadout _unit,
    getForcedFlagTexture _unit,
    _x in btc_chem_contaminated,
    [_unit] call ace_medical_fnc_serializeState
];
btc_player_serialize set [_unit getVariable ["btc_respawn_slotName", [0, 0, 0]], _data];
