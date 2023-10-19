import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleApiSettings {
	static String spreadsheetId = "1uv37jqIgqYYWZBV8JdRaSmIRTQE_Z_T7N-m54IgY8XU";
	static String range = 'chara!A1:A7';

	static Future<SheetsApi> getClient() async {
		final clientId = "114695951693370576165";
		final private_key_id = "ca91172278dec0d583a92faa6436f07d1adf7de3";
		final private_key = "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCaEn8STijJJwtq\niD3S5qBKLSsjfF0tvu1leBVC8eRLw2hAgg8FhlCPPxSntMbXjQLi0eFtesJ9vd+3\nbaAOY4UEN8zg6Z+UfpgCqLAAtgLz7irJ6ens/QRXM5if6g2SWS41TgwJerFM+4vv\nW/1uVfNjf6CKqxstlU2Ls+aIUZdDjgCvzg4zJELQiwZZhOQWlPFrcejpelGAOSFx\nwLUx8xkqFDmylTQebNs3bCvm+299GEcAOo3DH93jDALlZXducm16LtZmrM2upyjZ\n2bJWcH3GjtX9AYNbXtiWPpDSgWSYkSpVp1d6BmD2wskYQLAWv4yCYRZF+4BrrMBI\nklU1MC5dAgMBAAECggEABAkM+/lBFzenFGS6Hc59j0PMl/LXa+3OwPQatnSocpWN\nIvdlFlN0w7O2wke5V4bxduhhW6E1+94fwGmmIgpYPwqJGrDzxYtlRtiNN4+M1z+7\nLiuqvVLJLNGEo1eZgGZGkA3ZwdvNTgNeoGfL5PpqVAZROaCOpyx8afbNyG8+o33H\nuYrliltGFGNdG2bfbjkPTmhuWGSg1GUe3sdAQVEAVuvDLt+Dp/bchQFe3+EXn2Vz\n26twmtsgwHVlLk/zEZbydSCzXybOcg4QVq0ONPwszgC80YWPpZD7zgbJuvf4BYHj\n8t4hjW2MXTVdb81IP36GOS749dnK/4DSnjZfu/WpzwKBgQDTKH6RzjQvueDxuzlT\nDkOLrnGMTjDLWP5DS9QBXjS7n28LuBXtV2hneLxHhuCWNuPJ4NAgcwVybi9FtJ0X\nU1Oth0HHpOOSrxc8X3w8MXgOFSmXrExwe0DvjYhVe4fq27Jt2sWDXsgnwJGa8ECs\n20uTcBu1PKzOM8QadYMKuKSXXwKBgQC6yo4Jve2MdwSI+6kHNlRNIofkkxaiQ0ac\nPjdqvPYe6gFoWMyaAEjo/USacF288HAbatYj5D1gjmr/mg59QdHcWVywhafiDnmR\ninzymKWLoVtHE22vThayOSsxwaesX+TbiY+DyQ0v7TpnxjSm33eYLGp+Xm3Qhjv/\n01v1Db+/wwKBgQCo0k5nanKE2dsDyYlqYxQT4FN+NqGCYtNeoIiO02/btfuFZhd5\n25FocLovgaGb16TFKc2cs/ld5MQ8ucuC86cKLQKliKo+A2jTZxAf2/k9YSQQ1LuE\njrZ7EDA5D/u6BQ6iD/AsOSJTzf1b38wFp4rEBTTR8QHEFtUpxlwPvVIyhwKBgQCe\n3YV+fZ2a+OLPipKRAsEiNXs0iXEXonZcjoHdc0c0tbtqvxOM6y8XkciWPXlMJ4aB\nmxTzw7v78kTIjYNDPwa5DPvLWnGVzs/QW+O3BOLPZfXW9ow0LAsbm4nEMLtl3M0t\ndsqrwARKPc6N0kKXprn1n9kXD0MAthozk9TDD+WEtwKBgQDNBcSDpPeIQOz5Y6Nr\nn8od6TVzOyJjq/76nG0I/Mm5E9dWV9A9Mx33Nd3xNa/axEixG6RHaZlQ8dZVmS52\nodEfthGueQE6BmRJh8RvVyfAfIF+wEOX/hs2bkJSw/cWFaUVRVxEcgeQEMudxcUv\nMQIXMGwx4B8X6hdHrn2JYyhWRQ==\n-----END PRIVATE KEY-----\n";

		var credentials = ServiceAccountCredentials.fromJson({
			'private_key_id': private_key_id,
			'private_key': private_key,
			'client_id': clientId,
			'client_email': 'flutternovel@flutternovel.iam.gserviceaccount.com',
			'type': 'service_account',
		});
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

	static Future<List<List<dynamic>>?> createGoogleSheetsApiGetUrl() async {
		final sheetsApi = await getClient();

		ValueRange response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

		return response.values;
	}
}
