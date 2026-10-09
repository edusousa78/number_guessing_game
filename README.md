# Number Guessing Game

Um jogo de terminal em Bash no qual você tenta adivinhar um número secreto entre 1 e 1000. O projeto usa PostgreSQL para identificar jogadores e guardar o histórico das partidas.

## Funcionalidades

- Gera um número secreto aleatório entre 1 e 1000 a cada partida.
- Cria um perfil na primeira vez que um nome de usuário é usado.
- Mostra a quantidade de partidas e o melhor resultado de jogadores recorrentes.
- Dá dicas para palpites maiores ou menores que o número secreto.
- Registra no banco de dados cada partida concluída.
- Aceita nomes de usuário com até 22 caracteres.

## Requisitos

- Bash
- PostgreSQL em execução
- Cliente de linha de comando `psql`
- Uma role PostgreSQL chamada `freecodecamp` com permissão para criar e acessar o banco `number_guess`

O script se conecta ao banco `number_guess` usando a role `freecodecamp`. Configure a autenticação do PostgreSQL para que essa conexão funcione no seu ambiente.

## Configuração do banco de dados

Crie o banco:

```bash
createdb --username=freecodecamp number_guess
```

Em seguida, crie as tabelas e restrições:

```bash
psql --username=freecodecamp --dbname=number_guess <<'SQL'
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) NOT NULL UNIQUE
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id),
  number_of_guesses INTEGER NOT NULL
);
SQL
```

Se o banco ou as tabelas já existirem, não repita esses comandos sem antes verificar o conteúdo: `CREATE TABLE` falhará quando uma tabela com o mesmo nome já existir.

## Como executar

Na pasta do projeto, execute:

```bash
./number_guess.sh
```

Informe um nome de usuário e, em seguida, tente adivinhar o número:

```text
Enter your username:
ana
Welcome, ana! It looks like this is your first time here.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
250
...
You guessed it in <tentativas> tries. The secret number was <numero>. Nice job!
```

Em partidas futuras com o mesmo nome, o jogo exibirá o total de partidas registradas e o menor número de palpites usado para vencer.

## Estrutura

```text
number_guessing_game/
├── number_guess.sh
├── number_guess.sql
└── README.md
```

`number_guess.sql` é um dump de banco de dados para referência ou restauração controlada. Ele contém comandos que apagam e recriam o banco `number_guess`; revise o conteúdo e faça backup dos dados antes de executá-lo.
