# Swifty 
 
## Obj-C Wrappers
### Settings protocol
⚠️ Since Swift 5.1 use property wrapper @UserDefault ⚠️
Simple string-enum wrapper around UserDefaults:
``` swift
enum UserSettingsKeys: String, CaseIterable, SettingKey {

    case language
    case tutorialShowed

    static var clearKeys: [UserSettingsKeys] {
        return allCases // keys to remove on logout for example
    }
}

class UserSettings: Settings<UserSettingsKeys> {}
```
To read and write:
``` swift    
    let showed: Bool = settings[.tutorialShowed] ?? false
    ...
    settings[.tutorialShowed] = true

    settings[.language] = .dutch // where Language is RawRepresentable
```
Only supported types can be stored (check `SettingValue`). 
Also any `Codable` object:
``` swift
    settings.set(user, key: .currentUser) // by default encoded as .plist
    
    let currentUser: User? = settings.object(.currentUser)
```

### CoreData Primitives
 ⚠️ Since Swift 5.1 can be improved with @propertyWrapper ⚠️
 Similar string-enum wrapper for primitives in CoreData:
 ``` swift
    class FavoriteItem: NSManagedObject, Primitives {
        enum PrimitiveKey: String {
            case rating
            case type
        }
        
        // optionals
        var rating: Int16? {
            set { self[.rating] = newValue }
            get { return self[.rating] }
        }
        
        // RawRepresentable
        var type: FavoriteType? {
            set { self[.type] = newValue }
            get { return self[.type] }
        }
    }
 ```

## Table & Collection Controllers 
Boilerplate code for `DataSource` of `TableView` & `CollectionView` can be simplied to:
``` swift
    // where MyCell is a prototype in Storyboard 
    let controller = TableController<String, MyCell>(tableView: self.tableView) { cell, item in
        cell.textLabel?.text = item
    }
    
    // DataProvider is ExpressibleByArrayLiteral
    controller.update(provider: ["one", "two", "three"]) // aka reload data
```

Flexibility of `DataProvider`:
``` swift
    // single section with 3 rows
    let provider = DataProvider([1, 2, 3]) 
    
    // multiple section with optional titles
    let section1 = Section(title: "First", objects: [0,1,2]) // 3 rows
    let section2 = Section(title: "Second", objects: [3,4])  // 2 rows
    let provider = DataProvider(sections: [section1, section2])
    
    // NSFetchedResultsController and even PHFetchResult is supported
    let provider = DataProvider(frc: frc)
```

CoreData support:
``` swift
    // by default FRCTableController will listen to changes in context and do batch updates
    ...
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    let controller = FRCTableController<CoreDataEntity, EntityCell>(tableView: self.tableView, frc: frc) { cell, entity in
        cell.update(with: entity)
    }
```


## MVVM
### ViewController
### ViewModel
### StateController

## Reactive
### Observable
⚠️ Since Swift 5.1 use Combine's [Publisher](https://developer.apple.com/documentation/combine/publisher) ⚠️

### Future
⚠️ Since Swift 5.1 use Combine's [Future](https://developer.apple.com/documentation/combine/future) ⚠️

### Permissions
