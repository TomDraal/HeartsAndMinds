
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_massacre

Description:
    Fill me when you edit me !

Parameters:
    _taskID - Unique task ID. [String]

Returns:

Examples:
    (begin example)
        [false, "btc_side_fnc_massacre"] spawn btc_side_fnc_create;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]]
];

//// Choose an occupied City \\\\
private _useful = values btc_city_all select {
    !((_x getVariable ["type", ""]) in ["NameLocal", "Hill", "NameMarine", "StrongpointArea"])
};
if (_useful isEqualTo []) exitWith {[] spawn btc_side_fnc_create;};
[_useful, true] call CBA_fnc_shuffle;
private _city = objNull;
private _church = objNull;
while {_useful isNotEqualTo []} do {
    _city = _useful deleteAt 0;
    _church = nearestTerrainObjects [_city, ["CHURCH", "CHAPEL"], 470];
    if (_church isNotEqualTo []) then {
        break;
    };
};
if (_useful isEqualTo [] and _church isEqualTo []) exitWith {
    [] spawn btc_side_fnc_create;
};

private _pos = getPos _city;
private _radius = _city getVariable ["cachingRadius", 0];
private _roads = _pos nearRoads _radius;
_roads = _roads select {isOnRoad _x};
if (_roads isEqualTo []) exitWith {[] spawn btc_side_fnc_create;};
private _road = selectRandom _roads;

[_taskID, 9, objNull, _city getVariable "name"] call btc_task_fnc_create;
{
    private _church_taskID = _taskID + "ch" + str _forEachIndex;
    [[_church_taskID, _taskID], 23, _x, typeOf _x, false, false] call btc_task_fnc_create;
} forEach _church;

private _group = createGroup civilian;
private _civilians = [];
for "_i" from 1 to (2 + round random 2) do {
    _pos = getPos _road;

    private _direction = [_road] call btc_fnc_road_direction;
    private _unit = _group createUnit [selectRandom btc_civ_type_units, _pos, [], 0, "CAN_COLLIDE"];
    _unit setDamage 1;
    _civilians pushBack _unit;

    private _civ_taskID = _taskID + "cv" + str _i;
    [[_civ_taskID, _taskID], 23, _unit, typeOf _unit, false, false] call btc_task_fnc_create;
};

if (_civilians isEqualTo []) then {[_taskID, "CANCELED"] call btc_task_fnc_setState;};

waitUntil {sleep 5; 
    _taskID call BIS_fnc_taskCompleted ||
    _civilians select {!isNull _x} isEqualTo []
};

[[], _civilians] call btc_fnc_delete;

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {
    [[], _group] call btc_fnc_delete;
};

80 call btc_rep_fnc_change;

[_taskID, "SUCCEEDED"] call btc_task_fnc_setState;
