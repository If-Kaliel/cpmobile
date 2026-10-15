import "package:cp1mobile/models/pessoa.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cp1mobile/repositories/pessoa_repository.dart";
import "package:cp1mobile/utils/cores.dart";
import "package:cp1mobile/widgets/contador_lotacao.dart";
import "package:cp1mobile/widgets/pessoa_item.dart";

//Capacidade máxima do camarote
const int capacidadeMaxima = 67;

List<Pessoa> listPessoas = [];
Pessoa? deletedPessoa;
int? deletedPessoaPos;
String? errorNome;
String? errorId;

final PessoaRepository pessoaRepository = PessoaRepository();
final TextEditingController nomeController = TextEditingController();
final TextEditingController idController = TextEditingController();

class NightclubPage extends StatefulWidget {
  const NightclubPage({super.key});

  @override
  State<NightclubPage> createState() => _NightclubPageState();
}

class _NightclubPageState extends State<NightclubPage> {
  @override
  void initState(){
    super.initState();
    pessoaRepository.getListaPessoas().then((value){
      setState(() {
        listPessoas = value;
      });
    });
  }

  void mostrarFeedback(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  //Conta só quem ainda está dentro, quem já saiu não entra na conta
  int get pessoasNoAmbiente => listPessoas.where((pessoa) => pessoa.noAmbiente).length;

  bool get isFull => pessoasNoAmbiente >= capacidadeMaxima;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.roxoEscuro,
        leading: Icon(Icons.nightlife, color: Cores.rosaNeon),
        title: Text(
          "Camarote VIP",
          style: GoogleFonts.bitcount(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ContadorLotacao(
                pessoasNoAmbiente: pessoasNoAmbiente,
                capacidade: capacidadeMaxima,
                isFull: isFull,
              ),
              SizedBox(height: 16),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Ex: Maria Silva",
                  errorText: errorNome,
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: idController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Identificação",
                        hintText: "Ex: 123456",
                        errorText: errorId,
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: cadastrarPessoa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.roxoNeon,
                    ),
                    child: Icon(Icons.add, size: 30, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (Pessoa pessoa in listPessoas)
                      PessoaItem(
                        pessoa: pessoa,
                        onSaida: () => registrarSaida(pessoa),
                        onExcluir: () => excluirPessoa(pessoa),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cadastrarPessoa() {
    String nome = nomeController.text.trim();
    String identificacao = idController.text.trim();

    //Regra 3: não deixa cadastrar com campo vazio
    if (nome.isEmpty || identificacao.isEmpty) {
      setState(() {
        errorNome = nome.isEmpty ? "O nome não pode ser vazio" : null;
        errorId = identificacao.isEmpty ? "A identificação não pode ser vazia" : null;
      });
      return;
    }

    //Regra 4: não pode ter duas pessoas com a mesma identificação dentro do camarote
    bool idRepetido = listPessoas.any(
      (pessoa) => pessoa.identificacao == identificacao && pessoa.noAmbiente,
    );
    if (idRepetido) {
      setState(() {
        errorNome = null;
        errorId = "Já tem uma pessoa com essa identificação no camarote";
      });
      mostrarFeedback("Já existe uma pessoa com essa identificação no camarote!");
      return;
    }

    //Regra 1: se estiver lotado ninguém entra
    if (isFull) {
      setState(() {
        errorNome = null;
        errorId = null;
      });
      mostrarFeedback("Não é possível realizar a entrada. Ambiente lotado!");
      return;
    }

    Pessoa newPessoa = Pessoa(
      nome: nome,
      identificacao: identificacao,
      dataEntrada: DateTime.now(),
    );

    setState(() {
      listPessoas.add(newPessoa);
      errorNome = null;
      errorId = null;
    });
    pessoaRepository.saveListaPessoas(listPessoas);
    nomeController.clear();
    idController.clear();

    mostrarFeedback("Pessoa cadastrada com sucesso!");
  }

  Future<void> registrarSaida(Pessoa pessoa) async {
    //Regra 2: quem já saiu não pode registrar a saída de novo
    if (!pessoa.noAmbiente) {
      mostrarFeedback("A saída de ${pessoa.nome} já foi registrada!");
      return;
    }

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Registrar saída?"),
          content: Text("Deseja realmente registrar a saída de ${pessoa.nome}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("CANCELAR"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("CONFIRMAR"),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    if (!pessoa.noAmbiente) {
      return;
    }

    setState(() {
      pessoa.dataSaida = DateTime.now();
    });
    pessoaRepository.saveListaPessoas(listPessoas);

    mostrarFeedback("Saída registrada com sucesso!");
  }

  void excluirPessoa(Pessoa pessoa) {
    deletedPessoa = pessoa;
    deletedPessoaPos = listPessoas.indexOf(pessoa);

    setState(() {
      listPessoas.remove(pessoa);
    });
    pessoaRepository.saveListaPessoas(listPessoas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${pessoa.nome} foi removido(a) da lista."),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Cores.rosaNeon,
          onPressed: () {
            //Se a pessoa ainda estava dentro, não pode voltar se o camarote lotou
            if (deletedPessoa!.noAmbiente && isFull) {
              mostrarFeedback("Não é possível desfazer. Ambiente lotado!");
              return;
            }
            //Também não pode voltar se alguém com o mesmo ID entrou nesse meio tempo
            bool idRepetido = listPessoas.any(
              (p) => p.identificacao == deletedPessoa!.identificacao && p.noAmbiente,
            );
            if (deletedPessoa!.noAmbiente && idRepetido) {
              mostrarFeedback("Não é possível desfazer. Já existe alguém com essa identificação!");
              return;
            }
            setState(() {
              listPessoas.insert(deletedPessoaPos!, deletedPessoa!);
            });
            pessoaRepository.saveListaPessoas(listPessoas);
          },
        ),
      ),
    );
  }
}
