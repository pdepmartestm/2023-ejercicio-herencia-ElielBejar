class Planta{
   var anio
   var altura
   
   
   method horasSol(){
   	  return 0
   }
   
   method esFuerte(){
   	  return self.horasSol() > 10
   }
   
   method nuevasSemillas(){
   	  return self.esFuerte()
   }
   
   method espacio(){
   	 return 0
   }
}

class Menta inherits Planta{
	override method horasSol(){
		return 6
	}
	
	override method nuevasSemillas(){
		return super() || altura > 0.4
	}
	
	override method espacio(){
		return altura*3
	}
}

class Soja inherits Planta{
	override method horasSol(){
		if(altura < 0.5){
			return 6
		}else if(altura >= 0.5 && altura < 1){
			return 7
		}else{
			return 9
		}
	}
	override method nuevasSemillas(){
		return super() || (anio > 2007 && altura > 1)
	}
	
	override method espacio(){
		return altura/2
	}
}

class Quinoa inherits Planta{
	var property horasSol
	
	override method nuevasSemillas(){
		return super() || anio < 2005
	}
}

class SojaTransgenica inherits Soja{
	override method nuevasSemillas(){
		return false
	}
}

class Hierbabuena inherits Menta{
	override method espacio(){
		return super()*2
	}
}

