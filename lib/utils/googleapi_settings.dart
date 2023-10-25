import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleApiSettings {
	static String spreadsheetId = "1uv37jqIgqYYWZBV8JdRaSmIRTQE_Z_T7N-m54IgY8XU";
	static String range = 'chara!A2:B8';

	static Future<SheetsApi> getClient() async {
		final String jsonString = await rootBundle.loadString("json/googleapi_auth.json");
		final jsonData = json.decode(jsonString);

		var credentials = ServiceAccountCredentials.fromJson(jsonData);
		var scopes = [SheetsApi.spreadsheetsScope];

		var client = http.Client();
		var accessCredentials = await obtainAccessCredentialsViaServiceAccount(
			credentials,
			scopes,
			client
		);
		client = authenticatedClient(client, accessCredentials);

		final sheetsApi = SheetsApi(client);
		return sheetsApi;
	}

	static Future<List<List<dynamic>>> createGoogleSheetsApiGetUrl(String range) async {
		final sheetsApi = await getClient();

		ValueRange response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

		return response.values!;
	}
}
