import 'package:base_app/viewModel/HomePageViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = ChangeNotifierProvider((ref) => HomePageViewModel());
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(provider);
    var read = ref.read(provider);
    return Scaffold(
      body: _buildBody(watch,read),
    );
  }
  Widget _buildBody(HomePageViewModel watch, HomePageViewModel read){
    return  SafeArea(
      child: Column(
        children: [
        ElevatedButton(onPressed: (){
          read.getDataAndSendEmail(context,"oglcnkcr54_kcr@outlook.com");
        }, child: Text("tıkla")),
        ],
      ),
    );
  }

}
