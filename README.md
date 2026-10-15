# Camarote VIP 👑 — Controle de Lotação 2.0

Aplicativo em Flutter para controlar quem entra e quem sai do camarote de uma balada. Dá para cadastrar as pessoas na entrada, ver a lista de quem está dentro, registrar a saída e acompanhar a lotação em tempo real, sem deixar passar da capacidade máxima.

## Ambiente escolhido

**Balada (Camarote VIP)**, o mesmo ambiente do Checkpoint 01. A capacidade máxima do camarote é de **67 pessoas**.

## Integrantes

- Kaliel Aquino — RM 567587
- Paulo Henrique Muniz Diedrich — RM 567618

## Vídeo

Link do vídeo demonstrando o app: (https://youtu.be/7qXWnB1Ez8U)

## Funcionalidades

- Cadastro de pessoas com nome, identificação e data/hora da entrada (`TextField` + `TextEditingController`)
- Lista das pessoas com `ListView`, mostrando nome, ID, entrada, saída e situação
- Registro de saída com confirmação em `AlertDialog`
- Contador de pessoas no ambiente (ex: 12 / 67)
- Ações deslizando o item da lista (`Slidable`): **Saída** e **Excluir**, com opção de desfazer a exclusão
- Feedback das operações com `ScaffoldMessenger` e `SnackBar`
- Dados salvos no aparelho com `shared_preferences`

### Regras de negócio

1. A quantidade de pessoas dentro do camarote não passa da capacidade máxima
2. Quem já saiu não pode registrar a saída de novo
3. Não dá para cadastrar com nome ou identificação vazios
4. Não dá para cadastrar duas pessoas com a mesma identificação ao mesmo tempo
5. Todas as operações mostram um feedback para o usuário

## Organização do projeto

```
lib/
├── main.dart                        # MaterialApp, tema e imagem de fundo
├── models/pessoa.dart               # Classe Pessoa
├── pages/nightclub_page.dart        # Tela principal
├── repositories/pessoa_repository.dart  # Salvar/carregar a lista
├── utils/cores.dart                 # Cores do app em hexadecimal
└── widgets/
    ├── contador_lotacao.dart        # Card do contador de lotação
    └── pessoa_item.dart             # Item de cada pessoa da lista
```

## Como executar

1. Ter o [Flutter](https://docs.flutter.dev/get-started/install) instalado
2. Clonar o repositório:
   ```
   git clone https://github.com/If-Kaliel/cpmobile.git
   cd cpmobile
   ```
3. Instalar as dependências:
   ```
   flutter pub get
   ```
4. Rodar o app em um emulador ou celular:
   ```
   flutter run
   ```

Para gerar de novo o ícone do app (opcional):
```
dart run flutter_launcher_icons
```

## Tecnologias e pacotes

- Flutter / Dart
- [intl](https://pub.dev/packages/intl) — formatação de data e hora
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) — ações ao deslizar os itens da lista
- [google_fonts](https://pub.dev/packages/google_fonts) — fontes Bitcount e Poppins
- [shared_preferences](https://pub.dev/packages/shared_preferences) — salvar a lista no aparelho
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) — ícone personalizado do app
