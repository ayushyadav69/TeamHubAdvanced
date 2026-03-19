//
//  EmployeeSchemaV1.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import SwiftData

enum EmployeeSchemaV1: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            EmployeeEntity.self,
            SyncMetadataEntity.self
        ]
    }
}
