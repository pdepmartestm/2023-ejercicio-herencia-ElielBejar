class Planta{
   var anio
   var property altura
   
   
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
   
   method seAsociaBien(parcela){
   	   return parcela.criterioAsociacion(self)
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
	
	method parcelaIdeal(parcela){
		return parcela.superficie() > 6
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
	
	method parcelaIdeal(parcela){
		return parcela.horasSol() == self.horasSol()
	}
}

class Quinoa inherits Planta{
	var property horasSol
	
	override method nuevasSemillas(){
		return super() || anio < 2005
	}
	
	method parcelaIdeal(parcela){
		return parcela.plantas().all({planta => planta.altura() <= 1.5})
	}
}

class SojaTransgenica inherits Soja{
	override method nuevasSemillas(){
		return false
	}
	
	override method parcelaIdeal(parcela){
		return parcela.maximasPlantas() == 1
	}
}

class Hierbabuena inherits Menta{
	override method espacio(){
		return super()*2
	}
}

class Parcela{
	var ancho
	var largo
	var property horasSol
	var property plantas
	
	method superficie() = return ancho*largo
	
	method maximasPlantas(){
		if(ancho > largo){
			return self.superficie()/5
		}else{
			return self.superficie()/3 + largo
		}
	}
	
	method complicaciones(){
		return plantas.any({planta => planta.horasSol() < horasSol})
	}
	
	method plantar(planta){
		if(self.maximasPlantas() < (plantas.size() + 1)){
			throw new Exception (message = "falta de espacio") 
		}else if(horasSol >= planta.horasSol() + 2){
			throw new Exception (message = "insuficiente sol")
		}else{
			plantas.add(planta)
		}
	}
}

class parcelaEcologica inherits Parcela{
	method criterioAsociacion(planta){
		return self.complicaciones() == false && planta.parcelaIdeal(self)
	}
}

class parcelaIndustrial inherits Parcela{
	method criterioAsociacion(planta){
		return self.maximasPlantas() == 2 && planta.esFuerte()
	}
}

object inta{
	
	var parcelas = #{}
	
	method promedioPlantas(){
		return parcelas.sum({parcela => parcela.size()})/parcelas.size()
	}
	
	method parcelaMasAutosustentable(){
		const masCuatroPlantas = parcelas.filter({parcela => parcela.size()>4})
		return masCuatroPlantas.max({parcela => self.porcentajePlantasBienAsociadas(parcela)})
		
	}
	
	method porcentajePlantasBienAsociadas(parcela){
		const total = parcela.plantas().size()
		const bienAsociadas = parcela.plantas().filter({planta => planta.seAsociaBien(parcela)})
		const totalAsociadas = bienAsociadas.size()
		return (totalAsociadas/total)*100
	}
}


