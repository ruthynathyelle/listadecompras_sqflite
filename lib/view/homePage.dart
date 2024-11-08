import 'package:flutter/material.dart';
import 'package:listasqflite/model/item.dart';
import 'package:listasqflite/db/database_helper.dart';
import 'package:listasqflite/db/generatepdf.dart';
import 'package:listasqflite/db/animation_manager.dart';

class ListaComprasPage extends StatefulWidget {
  @override
  _ListaComprasPageState createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final AnimationManager animationManager = AnimationManager();
  bool showAnimation = false;

  List<Item> _itens = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _dbHelper.getItems();
    setState(() {
      _itens = items;
    });
  }

  Future<void> _addItem() async {
    if (_nomeController.text.isNotEmpty && _quantidadeController.text.isNotEmpty) {
      final item = Item(
        nome: _nomeController.text,
        quantidade: int.tryParse(_quantidadeController.text) ?? 1,
      );
      await _dbHelper.insertItem(item);
      _nomeController.clear();
      _quantidadeController.clear();
      _loadItems();

      // Fecha o diálogo antes de exibir a animação
      Navigator.of(context).pop();

      // Exibe a animação após adicionar o item
      setState(() {
        showAnimation = true;
      });

      // Atraso de 5 segundos para exibir a animação
      await Future.delayed(Duration(seconds: 4));

      // Esconde a animação após o atraso
      setState(() {
        showAnimation = false;
      });
    }
  }

  Future<void> _deleteItem(int? id) async {
    await _dbHelper.deleteItem(id);
    _loadItems(); 
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(221, 252, 248, 248),
          title: Text(
            "Adicionar Item",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: "Nome do Item",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                iconColor: Colors.orange[300],
              ),
              onPressed: () async {
                // Chama o método para adicionar o item e exibe a animação
                await _addItem();
              },
              child: Text(
                "Adicionar",
                style: TextStyle(color: Colors.orange[300]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      appBar: AppBar(
        title: Text("Lista de Compras"),
        backgroundColor: Colors.orange[300],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exibe a animação na tela com base no valor de showAnimation
            animationManager.animationWidget(showAnimation),
            Expanded(
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  final item = _itens[index];
                  return Card(
                    color: item.status ? Colors.orange[100] : Colors.white,
                    child: ListTile(
                      title: Text(
                        item.nome,
                        style: TextStyle(
                          color: item.status ? Colors.black : Colors.grey[700],
                          decoration: item.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        "Quantidade: ${item.quantidade}",
                        style: TextStyle(
                          color: item.status ? Colors.black : Colors.grey[700],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            activeColor: Colors.orange[300],
                            value: item.status,
                            onChanged: (value) async {
                              setState(() {
                                item.status = value!;
                              });
                              await _dbHelper.updateItemStatus(item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[300],
                foregroundColor: Colors.black,
              ),
              onPressed: () => GeneratePrinting().printingPdf(_itens), // Função para gerar o PDF
              child: Text("Gerar PDF"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        foregroundColor: Colors.black,
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
