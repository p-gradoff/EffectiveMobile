
# Effective Mobile

Наш минимализм - ваша продуктивность.


## Task tracker app

Приложение позволяет вам вести список задач, отмечать их выполнение, добавлять новые, редактировать и удалять существующие, а также осуществлять поиск.

### Подробности реализации
#### Архитектура

- В приложении реализована архитектура __VIPER__, где в качестве координирующего звена одного модуля выступает сущность __Configurator__, а связь между модулями обеспечивает __Router__.

#### Функционал

- При первом запуске приложения осуществляется загрузка первоначального списка задач из сети, после чего  __Launch manager__ исключает дальнейшие запросы в сеть.

- Приложение сохраняет все данные при окончании работы с ним и обеспечивает корректный доступ и изменение после повторной загрузки.

- Приложение поддерживает поиск по содержанию в заголовках и описаниях заметок.