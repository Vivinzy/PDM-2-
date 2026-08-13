import 'package:flutter/material.dart';

// Ponto de entrada do app: toda aplicação Flutter começa aqui.
void main() {
  runApp(const MeuApp());
}

// Widget raiz do aplicativo. É "Stateless" porque ele mesmo nunca muda,
// só define o tema e qual tela inicial mostrar.
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Alunos',
      debugShowCheckedModeBanner: false, // tira a faixa "DEBUG" do canto
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const CadastroAlunosPage(),
    );
  }
}

// "Modelo" do aluno: uma classe simples que agrupa nome, idade e curso
// numa única "caixinha" de dados, em vez de usar 3 listas soltas.
class Aluno {
  final String nome;
  final String idade;
  final String curso;

  Aluno({required this.nome, required this.idade, required this.curso});
}

// Tela principal. É "Stateful" porque a lista de alunos muda
// conforme o usuário cadastra novos alunos.
class CadastroAlunosPage extends StatefulWidget {
  const CadastroAlunosPage({super.key});

  @override
  State<CadastroAlunosPage> createState() => _CadastroAlunosPageState();
}

class _CadastroAlunosPageState extends State<CadastroAlunosPage> {
  // Controllers: "sensores" que leem o que foi digitado em cada campo.
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();

  // Lista que guarda todos os alunos cadastrados.
  final List<Aluno> _alunos = [];

  // Função chamada quando o botão "Cadastrar" é clicado.
  void _cadastrarAluno() {
    final nome = _nomeController.text.trim();
    final idade = _idadeController.text.trim();
    final curso = _cursoController.text.trim();

    // Validação simples: não deixa cadastrar campo vazio.
    if (nome.isEmpty || idade.isEmpty || curso.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // setState avisa o Flutter: "algo mudou, redesenhe a tela".
    setState(() {
      _alunos.add(Aluno(nome: nome, idade: idade, curso: curso));

      // Limpa os campos depois de cadastrar, pra facilitar o próximo.
      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();
    });
  }

  // Função pra remover um aluno da lista (bônus, não pedido mas útil).
  void _removerAluno(int index) {
    setState(() {
      _alunos.removeAt(index);
    });
  }

  // Boa prática: limpar os controllers quando a tela for destruída,
  // evitando consumo de memória desnecessário.
  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo Nome
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Campo Idade
            TextField(
              controller: _idadeController,
              keyboardType: TextInputType.number, // abre teclado numérico
              decoration: const InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Campo Curso
            TextField(
              controller: _cursoController,
              decoration: const InputDecoration(
                labelText: 'Curso',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Botão Cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cadastrarAluno,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Cadastrar'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alunos cadastrados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de alunos. Expanded faz ela ocupar o espaço restante
            // da tela, senão o Column não sabe quanto espaço dar pra ela.
            Expanded(
              child: _alunos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum aluno cadastrado ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _alunos.length,
                      itemBuilder: (context, index) {
                        final aluno = _alunos[index];
                        return Card(
                          child: ListTile(
                            title: Text(aluno.nome),
                            subtitle: Text(
                                'Idade: ${aluno.idade} | Curso: ${aluno.curso}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removerAluno(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}