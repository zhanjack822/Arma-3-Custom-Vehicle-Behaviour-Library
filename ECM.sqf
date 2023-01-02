if(isServer)then{
 addToSeaWizz = {
  params["_turret","_range"];
  _null = [_turret,_range]spawn {
         private["_turret","_range","_incoming","_target"];
   _turret = _this select 0;
   _range = _this select 1;
   while{alive _turret}do{
	// Selects every incoming missile
    _incoming = _turret nearObjects["MissileBase",_range];
    if(count _incoming > 0)then{
     _target = _incoming select 0;
     _fromTarget = _target getDir _turret;
     _dirTarget = direction _target;
     if((alive _target) && (_dirTarget <_fromTarget + 45) && (_dirTarget >_fromTarget - 45) && (_target distance _turret < 200)) then {
		// Determines chance of countermeasure success
		_rng = ceil (random 10);
		if(_rng <= 9)then{
			// Deflection angle
			_deflection = selectRandom [-50,50,-60,60];
			// Random selects pitch or roll to have deflection
			_yp = selectRandom [1,2];
			// 3D vector array for the missile's velocity
			_targetVelocity = velocity _target;
			// yaw
			if(_yp == 1)then{
				// Deflects missile direction in yaw
				_target setVelocity [(cos _deflection)*(_targetVelocity select 0) - (sin _deflection)*(_targetVelocity select 1),(sin _deflection)*(_targetVelocity select 0)+(cos _deflection)*(_targetVelocity select 1), _targetVelocity select 2];
				// removes missile from list of threats
				_incoming = _incoming - [_target];
			}
			// pitch
			else {
				// Deflects missile direction in pitch
				_target setVelocity [(cos _deflection)*(_targetVelocity select 0) + (sin _deflection)*(_targetVelocity select 2), _targetVelocity select 1,(cos _deflection)*(_targetVelocity select 2)-(sin _deflection)*(_targetVelocity select 0)];
				// removes missile from list of threats
				_incoming = _incoming - [_target];
			};
		}
		else {
			sleep 2;
		};
       
      sleep 0.01;
     };
    };
    if(count _incoming == 0)then{
        sleep 1;
    };
   };
  };
 };
};