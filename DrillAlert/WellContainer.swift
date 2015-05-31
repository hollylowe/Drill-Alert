//
//  WellContainer.swift
//  DrillAlert
//
//  Created by Lucas David on 5/30/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class WellContainer {
    var wells = Array<Well>()
    var favoriteWells = Array<Well>()
    
    func reloadWellsForUser(user: User) -> String? {
        var error: String?
        self.wells.removeAll(keepCapacity: false)
        self.favoriteWells.removeAll(keepCapacity: false)
        
        let (newWells, optionalError) = Well.getWellsForUser(user)
        if optionalError == nil {
            // Get all of the favorite wellbores this
            // user has.
            let localFavoriteWellbores = FavoriteWellbore.fetchAllInstances()
            var favoriteWellboreIDs = Array<String>()
            
            for favoriteWellbore in localFavoriteWellbores {
                favoriteWellboreIDs.append(favoriteWellbore.wellboreID as String)
            }
            
            // Then go through every well, if that well's id
            // is the same as a favorite wells id, throw
            // that well into the favorite wells array
            // so it shows in the favorites segment control.
            for well in newWells {
                var wellFavoriteWellbores = Array<Wellbore>()
                
                for wellbore in well.wellbores {
                    // IF this wellbore is favorited
                    if contains(favoriteWellboreIDs, wellbore.id) {
                        wellbore.isFavorite = true
                        wellFavoriteWellbores.append(wellbore)
                    }
                }
                
                if wellFavoriteWellbores.count > 0 {
                    let favoriteWell = Well(id: well.id, name: well.name, location: well.location)
                    favoriteWell.wellbores = wellFavoriteWellbores
                    self.favoriteWells.append(favoriteWell)
                }
            }
            
            self.wells = newWells
        } else {
            error = optionalError
        }
        
        return error
    }
}