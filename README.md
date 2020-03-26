# Todos Conectados

**tl;dr**: Iniciativa social para facilitar el trabajo remoto como respuesta a la contingencia del Virus Covid-19.

## Índice

* [Acerca del proyecto](https://github.com/todosconectados/api#acerca-del-proyecto)
* [Comienza](https://github.com/todosconectados/api#comienza)


## Acerca del Proyecto

Iniciativa social para crear un servicio gratuito de conferencias telefónicas. El proyecto cuenta ya con:

* [x] README.md
* [x] Etiquetas estándar en la sección de *issues*.
* [x] Proyecto en Rails 6 base.
* [x] LICENCIA
* [x] CONTRIBUTION.md

## ¿Cómo ayudar?
Para contribuir revisa la [Guia de Contribución](https://github.com/todosconectados/api/blob/master/CONTRIBUTING.md) donde encontrarás la información fundamental para comenzar a contribuir en los proyectos.

## Configuración inicial

- Cree un nuevo archivo llamado `.env` en el directorio raíz de la aplicación basado en ` .env.sample`. Rellene las variables adecuadas antes de ejecutar el demonio del servidor ruby.

```
TODOS_CONECTADOS_USERNAME=
TODOS_CONECTADOS_DATABASE_PASSWORD=
...
```

- Instalar dependencias de Rails, a través de `bundle command`.

```bash
bundle install
```

- Configurar entorno de `desarrollo` y` prueba` db.

```bash
bundle exec rails db:setup
```

## Ejecutar / Desarrollo

* `rails s`
* Visita tu aplicación en [http://localhost:3000](http://localhost:3000).
