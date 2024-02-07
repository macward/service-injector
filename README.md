# Service Injector

# How to use it?

Crea una clase que conforme le protocolo 'DependencyRegister'.
```
public struct Dependencies: DependencyRegister {
    public static func load() {
        ...
    }
}
```

ahora debes registrar un servicio dentro del metodo load()

```
ServiceLocator.register(as: AnyCustomType.self, 
                        withLifecycle: .runtime, 
                        using: AnyCustomType())
```

Cuando quieras cargar las dependencias puedes llamar Dependencies.load()
```

init() {
    Dependencies.load()
}
```

Utilizando el injector
```
@Injector(.runtime) var property: AnyCustomType
```