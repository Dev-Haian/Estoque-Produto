import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'package:uuid/uuid.dart';

class ProductFormScreen extends StatefulWidget {

  final Product? product;

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'Cabelo';
  

  @override
  void initState() {
    if (widget.product != null) {
      _codeController.text = widget.product!.code;
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _type = widget.product!.type;
    }
    super.initState();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? Uuid().v4(),
        code: _codeController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        type: _type,
      );

      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (widget.product == null) {
        productProvider.addProduct(newProduct);
      } else {
        productProvider.updateProduct(newProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Adicionar Serviço' : 'Editar Serviço'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.save),
        //     onPressed: _saveForm,
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o código do Serviço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o nome do serviço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a descrição do serviço';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: ['Cabelo', 'Manicure', 'Pedicure', 'Depilação', 'Manicure e Pedicure', ].map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo'),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _saveForm
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
