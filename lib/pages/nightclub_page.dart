import "package:cp1mobile/models/pessoa.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:cp1mobile/repositories/pessoa_repository.dart";

//Capacidade máxima do camarote
const int capacidadeMaxima = 67;

List<Pessoa> listPessoas = [];
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

  //Conta só quem ainda está dentro, quem já saiu não entra na conta
  int get pessoasNoAmbiente => listPessoas.where((pessoa) => pessoa.noAmbiente).length;

  bool get isFull => pessoasNoAmbiente >= capacidadeMaxima;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A0526),
        leading: Icon(Icons.nightlife, color: Color(0xFFFF2E9A)),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xCC1A0526),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, color: Colors.white),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Pessoas no ambiente: $pessoasNoAmbiente / $capacidadeMaxima",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        isFull ? "Camarote lotado! Não é possível registrar uma nova entrada." : "Pode entrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: isFull ? Color(0xFFFF3B3B) : Color(0xFF39FF14)),
                      ),
                    ),
                  ],
                ),
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
                      backgroundColor: Color(0xFFB026FF),
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
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pessoa.nome,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  Text("ID: ${pessoa.identificacao}"),
                                  Text(
                                    "Entrada: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataEntrada)}",
                                  ),
                                  //Só mostra a saída se a pessoa já saiu
                                  if (!pessoa.noAmbiente)
                                    Text(
                                      "Saída: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataSaida!)}",
                                    ),
                                  Text("Situação: ${pessoa.situacao}"),
                                ],
                              ),
                            ),
                            TextButton(
                              //Se a pessoa já saiu o botão fica desabilitado
                              onPressed: pessoa.noAmbiente ? () => registrarSaida(pessoa) : null,
                              child: Text("Saída"),
                            ),
                          ],
                        ),
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
      return;
    }

    //Regra 1: se estiver lotado ninguém entra
    if (isFull) {
      setState(() {
        errorNome = null;
        errorId = null;
      });
      return;
    }

    setState(() {
      Pessoa newPessoa = Pessoa(
        nome: nome,
        identificacao: identificacao,
        dataEntrada: DateTime.now(),
      );
      listPessoas.add(newPessoa);
      errorNome = null;
      errorId = null;
    });
    pessoaRepository.saveListaPessoas(listPessoas);
    nomeController.clear();
    idController.clear();
  }

  void registrarSaida(Pessoa pessoa) {
    //Regra 2: quem já saiu não pode registrar a saída de novo
    if (!pessoa.noAmbiente) {
      return;
    }
    setState(() {
      pessoa.dataSaida = DateTime.now();
    });
    pessoaRepository.saveListaPessoas(listPessoas);
  }
}
