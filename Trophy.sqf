if(isServer)then{
 addToTrophy = {
  params["_vehicle","_range"];
  _null = [_vehicle,_range]spawn {
	private["_vehicle","_range","_incoming","_target"];
	_vehicle = _this select 0;
	_range = _this select 1;
	while{alive _vehicle}do{
	 // Enables Trophy to intercept large caliber shells
	 _incoming = _vehicle nearObjects ["ShellBase",_range];
	 
	 // Enables Trophy to intercept missiles
	 _incoming = _incoming + (_vehicle nearObjects ["MissileBase",_range]);
	 
	 // Enables Trophy to intercept rockets
	 _incoming = _incoming + (_vehicle nearObjects ["RocketBase",_range]);
	 
	 /* The order in which these threat types are listed determine the order in which they
	 are added to the array of incoming threats. Thus, large calibers shells have priority
	 over missiles, which have priority over rockets
	 */
	 
	 while{count _incoming > 0} do{
		// Takes first element of _incoming and attempts to engage it
		_target = _incoming select 0; 
		
		// True bearing of the vehicle from the projectile's perspective
		_fromTarget = _target getDir _vehicle; 
		
		// Heading the projectile is flying at
		_dirTarget = direction _target; 
		
		// Vertical coordinate of projectile
		_targetZ = (getPosASL _target) select 2; 
		
		// Vertical coordinate of vehicle
		_vehicleZ = ((getPosASL _vehicle) select 2) + 1.8;
		
		// Approach angle of projectile
		_targetSlope = (_targetZ - _vehicleZ) / (_vehicle distance2D _target);
		
		/*
		Trophy will only engage if the vehicle is 30 degrees left or right of the projectile's heading
		and isn't coming too steeply from above or below. The elevation limits are set at 80 degrees up
		or down by default
		*/
		
		if ((_dirTarget < _fromTarget + 30) && (_dirTarget > _fromTarget - 30) && (_targetSlope < 5.76) && (_targetSlope > -5.76)) then {
			// Creates small explosion
			"SmallSecondary" createVehicle (getPos _target); 
			
			// Deletes projectile
			deleteVehicle _target; 
			
			// Removes _target from the array of projectiles
			_incoming = _incoming - [_target]; 
			
			// Script has a delay before engaging the next projectile in the array
			sleep 0.1; 
		};
	 };
	 
	 /* 
	 This is how often the system checks for incoming projectiles
	 within the range specified in the init.sqf. If you want the APS to
	 intercept faster munitions like tank shells, you need to decrease the interval length.
	 This can have performance issues if too many vehicles with the APS are included in a mission
	 and the interval is very short.
	 */
	 if(count _incoming == 0)then{
	 sleep 0.03; 
	 };
	};
  };
 };
}
  