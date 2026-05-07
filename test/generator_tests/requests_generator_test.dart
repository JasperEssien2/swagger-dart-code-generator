import 'package:swagger_dart_code_generator/src/extensions/yaml_extensions.dart';
import 'package:swagger_dart_code_generator/src/code_generators/swagger_requests_generator.dart';
import 'package:swagger_dart_code_generator/src/models/generator_options.dart';
import 'package:swagger_dart_code_generator/src/swagger_models/swagger_root.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'models_generator_test.dart'
    show openApiAnyOfResponseJson, openApiAnyOfResponseYaml;
import 'test_data.dart';

void main() {
  group('Requests generator tests', () {
    final root = SwaggerRoot.parse(carsService);

    test('Should generate CarsApi', () {
      final result = SwaggerRequestsGenerator(GeneratorOptions(
        inputFolder: '',
        outputFolder: '',
        ignoreHeaders: true,
        responseOverrideValueMap: [
          ResponseOverrideValueMap(
            method: 'get',
            url: '/cars/schemaRefBody',
            overriddenValue: 'String',
          ),
          ResponseOverrideValueMap(
            method: '',
            url: '/cars/returnTypeTests',
            overriddenValue: 'int',
          ),
        ],
      )).generate(
        swaggerRoot: root,
        className: 'CarsService',
        fileName: 'cars_service',
        allEnums: [],
      );

      final result2 = SwaggerRequestsGenerator(GeneratorOptions(
          inputFolder: '',
          outputFolder: '',
          defaultHeaderValuesMap: [
            DefaultHeaderValueMap(
              defaultValue: '120',
              headerName: 'id',
            ),
          ],
          includePaths: [
            'car'
          ])).generate(
        swaggerRoot: root,
        allEnums: [],
        className: 'CarsService',
        fileName: 'cars_service',
      );

      expect(result2, contains('Future<chopper.Response<CarModel>>'));
      expect(result,
          contains('Future<chopper.Response<String>> carsSchemaRefBodyGet'));
      expect(result,
          contains('Future<chopper.Response<CarModel>> carsSchemaRefBodyPost'));
      expect(result,
          contains('Future<chopper.Response<int>> carsReturnTypeTestsGet'));
      expect(result,
          contains('Future<chopper.Response<int>> carsReturnTypeTestsPost'));
      expect(result,
          contains('Future<chopper.Response<int>> carsReturnTypeTestsPut'));
      expect(result, contains('Future<chopper.Response<CarModel>> carsGet'));
      expect(result, contains('Future<chopper.Response<CarModel>> carsPost'));
      expect(result,
          contains('Future<chopper.Response<CarModel>> carsMultipartPost'));
    });

    test('Should use generated sealed response model for JSON anyOf response',
        () {
      final root = SwaggerRoot.parse(openApiAnyOfResponseJson);
      final result = SwaggerRequestsGenerator(GeneratorOptions(
        inputFolder: '',
        outputFolder: '',
        ignoreHeaders: true,
      )).generate(
        swaggerRoot: root,
        className: 'PetsService',
        fileName: 'pets_service',
        allEnums: [],
      );

      expect(result,
          contains('Future<chopper.Response<PetSearchResponse>> petsSearchGet'));
      expect(result, contains('generatedMapping.putIfAbsent(PetSearchResponse'));
    });

    test('Should use generated sealed response model for YAML anyOf response',
        () {
      final yaml = loadYaml(openApiAnyOfResponseYaml) as YamlMap;
      final root = SwaggerRoot.fromJson(yaml.toMap());
      final result = SwaggerRequestsGenerator(GeneratorOptions(
        inputFolder: '',
        outputFolder: '',
        ignoreHeaders: true,
      )).generate(
        swaggerRoot: root,
        className: 'PetsService',
        fileName: 'pets_service',
        allEnums: [],
      );

      expect(result,
          contains('Future<chopper.Response<PetSearchResponse>> petsSearchGet'));
      expect(result, contains('generatedMapping.putIfAbsent(PetSearchResponse'));
    });
  });
}
