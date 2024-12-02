# Sistema de Archivos Seguro

Sistema seguro de gestión de archivos con comunicación entre Windows y Linux, que incluye encriptación, firma digital y sincronización de bases de datos.

## Características

- Gestión de usuarios en ambos sistemas operativos
- Generación y gestión de llaves públicas/privadas
- Encriptación y firma de archivos
- Comunicación segura entre servidores
- Sincronización automática de bases de datos
- Interfaces gráficas para ambos sistemas

## Requisitos

### Windows
- PowerShell 5.1 o superior
- SQL Server 2019 o superior
- .NET Framework 4.7.2 o superior

### Linux
- Bash 4.4 o superior
- MySQL 8.0 o superior
- Dialog (para interfaz TUI)
- OpenSSL

## Instalación

### Windows

1. Ejecutar PowerShell como administrador
2. Navegar al directorio del proyecto
3. Ejecutar:
```powershell
.\Setup.ps1
```

### Linux

1. Abrir terminal
2. Navegar al directorio del proyecto
3. Ejecutar:
```bash
chmod +x setup.sh
./setup.sh
```

## Estructura del Proyecto

```
├── windows/
│   ├── src/
│   │   ├── Crypto/
│   │   │   ├── GestorLlaves.ps1
│   │   ├── Database/
│   │   │   ├── GestorDB.ps1
│   │   ├── GUI/
│   │   │   └── MainWindow.ps1
│   │   └── Utils/
│   │       └── FileUtils.ps1
│   └── Setup.ps1
├── linux/
│   ├── src/
│   │   ├── crypto/
│   │   │   ├── gestor_llaves.sh
│   │   ├── database/
│   │   │   ├── gestor_db.sh
│   │   ├── gui/
│   │   │   └── main_menu.sh
│   │   └── utils/
│   │       └── dialog_utils.sh
│   └── setup.sh
└── README.md
```

## Uso

### Windows

1. Iniciar la aplicación:
```powershell
.\windows\src\GUI\MainWindow.ps1
```

### Linux

1. Iniciar la aplicación:
```bash
./linux/src/gui/main_menu.sh
```

## Funcionalidades

### Gestión de Usuarios
- Crear usuarios nuevos
- Sincronización automática entre sistemas
- Gestión de llaves públicas/privadas

### Gestión de Archivos
- Encriptación/desencriptación
- Firma digital
- Transferencia segura entre sistemas

### Monitoreo
- Consulta de procesos remotos
- Logs de operaciones
- Estado de sincronización

## Seguridad

- Encriptación asimétrica para archivos
- Firmas digitales para verificación
- Almacenamiento seguro de llaves

## Mantenimiento

### Windows
Los logs se encuentran en:
```
C:\ProgramData\SecureFileSystem\logs
```

### Linux
Los logs se encuentran en:
```
/var/log/secure-file-system
```

## Contribuir

1. Fork del repositorio
2. Crear rama para feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit de cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abrir Pull Request

## Licencia

Distribuido bajo la Licencia MIT. Ver `LICENSE` para más información.