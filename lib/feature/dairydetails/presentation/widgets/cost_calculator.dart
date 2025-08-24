import 'package:reactive_forms/reactive_forms.dart';

class CostCalculator {
  static void attachListener({
    required FormGroup liveStockForm,
    required FormGroup dairyForm,
    required FormGroup incomeForm,
  }) {
    
    int parseInt(dynamic value) {
      final str = value?.toString() ?? '0';
      final digits = str.replaceAll(RegExp(r'[^\d]'), '');
      return int.tryParse(digits.isEmpty ? '0' : digits) ?? 0;
    }

    liveStockForm.valueChanges.listen((formValues) {
      final values = formValues ?? {};

      final animals = parseInt(values['noOfAnimals']);
      final noOfAnimalsBatch1 = parseInt(values['noOfAnimalsBatch1']);
      final costOfAnimal = parseInt(values['costOfAnimal']);
      final costOfCalf = parseInt(values['costOfCalf']);
      final floorSpaceAdult = parseInt(values['floorSpaceAdult']);
      final floorSpaceCalf = parseInt(values['floorSpaceCalf']);
      final costOfConstruction = parseInt(values['costOfConstruction']);
      final averageMilkYield = parseInt(values['averageMilkYield']);
      final insurancePremium = parseInt(values['insurancePremium']);
      final veterinary = parseInt(values['veterinary']);
      final feed = parseInt(values['costConcentrateFeed']);
      final sellingPrice = parseInt(values['sellingPrice']);
      final salePrice = parseInt(values['salePrice']);
      final lactationDays = parseInt(values['lactationDays']);
      final value = parseInt(values['value']);

      final power = parseInt(values['power']);
      final salary = parseInt(values['salary']);
      final admin = parseInt(values['admin']);
      final miscExpenses = parseInt(values['miscExpenses']);

      //cost calculations

      final costOfMilch = animals * costOfAnimal;
      final costShedAdult = animals * floorSpaceAdult * costOfConstruction;
      final costShedCalf = noOfAnimalsBatch1 * floorSpaceCalf * costOfConstruction;
      final capitalCost = costOfMilch + costShedAdult + costShedCalf;
      final costOfFirstBatch = noOfAnimalsBatch1 * feed * 30;
      final costOfInsurance = (2 * costOfAnimal * 0.05 * insurancePremium).toInt();
      final reccuringCost = costOfFirstBatch + costOfInsurance;
      final totalCost = capitalCost + reccuringCost;
      final margin = (totalCost * 0.15).toInt();
      final loanAmountB = totalCost - margin;

      dairyForm.patchValue({
        'costOfMilch': costOfMilch.toString(),
        'costShedAdult': costShedAdult.toString(),
        'costShedCalf': costShedCalf.toString(),
        'capitalCost': capitalCost.toString(),
        'costOfFirstBatch': costOfFirstBatch.toString(),
        'costOfInsurance': costOfInsurance.toString(),
        'reccuringCost': reccuringCost.toString(),
        'totalCost': totalCost.toString(),
        'margin': margin.toString(),
        'loanAmountB': loanAmountB.toString(),
      });

      // Income calculation
      final lactation = lactationDays;
      final milkYield = animals * averageMilkYield;
      final milkIncome = milkYield * sellingPrice;
      final gunnnyIncome = animals * salePrice;
      final calvesIncome = noOfAnimalsBatch1 * costOfCalf;
      final mannureIncome = animals * value;

      final totalIncome = lactation +
          milkYield +
          milkIncome +
          gunnnyIncome +
          calvesIncome +
          mannureIncome;

      final feedingCost = animals * feed;
      final medicineCost = animals * veterinary;
      final insurance = animals * insurancePremium;
      final totalExpenses = feedingCost +
          medicineCost +
          power +
          salary +
          admin +
          miscExpenses +
          insurance;

      final incomeOverExpenditure = totalIncome - totalExpenses;

      incomeForm.patchValue({
        'lactation': lactation.toString(),
        'milkYield': milkYield.toString(),
        'milkIncome': milkIncome.toString(),
        'gunnnyIncome': gunnnyIncome.toString(),
        'calvesIncome': calvesIncome.toString(),
        'mannureIncome': mannureIncome.toString(),
        'totalIncome': totalIncome.toString(),
        'feedingCost': feedingCost.toString(),
        'medicineCost': medicineCost.toString(),
        'power': power.toString(),
        'salary': salary.toString(),
        'admin': admin.toString(),
        'miscExpenses': miscExpenses.toString(),
        'insurance': insurance.toString(),
        'totalExpenses': totalExpenses.toString(),
        'incomeOverExpenditure': incomeOverExpenditure.toString(),
      });
    });
  }
}
