import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      home: const CadastroAlunosPage(),
    );
  }
}

// Compatibilidade com o nome padrão do template Flutter.
class MyApp extends MeuApp {
  const MyApp({super.key});
}

// Referência para a coleção "alunos" no Firestore.
final CollectionReference alunosCollection =
    FirebaseFirestore.instance.collection('alunos');

// Tela principal. É "Stateful" porque os campos de texto mudam,
// mas a lista de alunos agora vem direto do Firestore em tempo real.
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

  // Função chamada quando o botão "Cadastrar" é clicado.
  // Agora grava o aluno direto no Firestore, em vez de numa lista local.
  Future<void> _cadastrarAluno() async {
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

    // add() cria um novo documento na coleção "alunos" com um ID automático.
    await alunosCollection.add({
      'nome': nome,
      'idade': idade,
      'curso': curso,
      'criadoEm': FieldValue.serverTimestamp(),
    });

    // Limpa os campos depois de cadastrar, pra facilitar o próximo.
    _nomeController.clear();
    _idadeController.clear();
    _cursoController.clear();
  }

  // Remove o aluno do Firestore usando o ID do documento.
  Future<void> _removerAluno(String docId) async {
    await alunosCollection.doc(docId).delete();
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
      appBar: AppBar(title: const Text('Cadastro de Alunos')),
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

            // StreamBuilder "escuta" a coleção no Firestore. Toda vez que
            // um aluno é adicionado ou removido em qualquer dispositivo,
            // essa lista atualiza sozinha, em tempo real.
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: alunosCollection.orderBy('criadoEm').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum aluno cadastrado ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          title: Text(data['nome'] ?? ''),
                          subtitle: Text(
                            'Idade: ${data['idade']} | Curso: ${data['curso']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerAluno(doc.id),
                          ),
                        ),
                      );
                    },
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