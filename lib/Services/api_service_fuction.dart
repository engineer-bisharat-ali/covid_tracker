import 'dart:convert';
import 'package:covid_tracker/Models/countries_list_model.dart';
import 'package:covid_tracker/Models/world_states_model.dart';
import 'package:covid_tracker/constant/api_url.dart';
import 'package:http/http.dart' as http;

class ApiService {
// Method for world states covid states

  Future<worldStatesModel> getWorldStates() async {
    var response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      return worldStatesModel.fromJson(data);
      
    } else {
      throw Exception("error");
    }
  }



  Future<List<CountriesListModel>> getCountriesData() async {
    var response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {
     List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => CountriesListModel.fromJson(data)).toList();
      
    } else {
      throw Exception("error");
    }
  }
  
}
