//
//  Points.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import Foundation
import SwiftyJSON


class Points {
    
    
    var id: Int
    var latitudCiudadano: Double
    var longitudCiudadano: Double
    var estado: Int

    var fotoBasura: String
    
    var ciudadanoId: Int
    var createdAt: String
    var updatedAt: String
    
    init(id: Int, latitudCiudadano: Double, longitudCiudadano: Double, estado: Int, fotoBasura: String, ciudadanoId: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.latitudCiudadano = latitudCiudadano
        self.longitudCiudadano = longitudCiudadano
        self.estado = estado
        self.fotoBasura = fotoBasura
        self.ciudadanoId = ciudadanoId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static func from(json: JSON) -> Points {
        return Points.init(id: json["id"].intValue, latitudCiudadano: json["latitud_ciudadano"].doubleValue, longitudCiudadano: json["longitud_ciudadano"].doubleValue, estado: json["estado"].intValue, fotoBasura: json["foto_basura"].stringValue, ciudadanoId: json["ciudadano_id"].intValue, createdAt: json["created_at"].stringValue, updatedAt: json["updated_at"].stringValue)
    }
    static func from(jsonArray: [JSON]) -> [Points] {
        var resultArray: [Points] = []
        jsonArray.forEach({resultArray.append(Points.from(json: $0))})
        return resultArray
    }
    

}
