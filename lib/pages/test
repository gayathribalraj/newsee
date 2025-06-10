import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/dynamic_card.dart'; // Custom InfoCardWidget

class Loan extends StatelessWidget {
  final String title;

  Loan(String s, {super.key, required this.title});

  final form = FormGroup({
    'typeofloan': FormControl<String>(validators: [Validators.required]),
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
  });

  InfoCard buildInfoCardFromProduct(ProductMaster product) {
    return InfoCard(
      title: 'Loan Product Info',
      subtitle: product.prdDesc,
      labels: [
        InfoLabel(
          icon: Icons.money,
          label: 'Amount From',
          value: product.prdamtFromRange.toString(),
        ),
        InfoLabel(
          icon: Icons.attach_money,
          label: 'Amount To',
          value: product.prdamtToRange.toString(),
        ),
        InfoLabel(
          icon: Icons.qr_code_2,
          label: 'Product Code',
          value: product.prdCode,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _context = context;
    return BlocProvider(
      create: (context) =>
          LoanproductBloc()..add(LoanproductInit(loanproductState: LoanproductState.init())),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loan Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<LoanproductBloc, LoanproductState>(
          listener: (context, state) {
            BuildContext ctxt = context;
            if (state.showBottomSheet == true) {
              openBottomSheet(
                context,
                0.7,
                0.5,
                0.9,
                (context, scrollController) => Expanded(
                  child: ListView.builder(
                    itemCount: state.productmasterList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(4.0),
                          onTap: () {
                            ProductMaster selectedProduct = state.productmasterList[index];
                            ctxt.read<LoanproductBloc>().add(
                                  ResetShowBottomSheet(selectedProduct: selectedProduct),
                                );
                          },
                          leading: Text(state.productmasterList[index].prdDesc),
                          subtitle: Text(
                            'Amount To :${state.productmasterList[index].prdamtToRange}',
                          ),
                          title: Text(
                            'Amount From:${state.productmasterList[index].prdamtFromRange}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            if (state.selectedProduct != null && state.showBottomSheet == false) {
              LoanproductState.init();
              Navigator.of(_context).pop();
            }
          },
          builder: (context, state) {
            return ReactiveForm(
              formGroup: form,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchableDropdown<ProductSchema>(
                        controlName: 'typeofloan',
                        label: 'Type Of Loan',
                        items: state.productSchemeList,
                        onChangeListener: (ProductSchema val) {
                          form.controls['typeofloan']?.updateValue(val.optionDesc);
                          context.read<LoanproductBloc>().add(
                                LoanProductDropdownChange(field: val),
                              );
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'maincategory',
                        label: 'Main Category',
                        items: state.mainCategoryList,
                        onChangeListener: (Product val) {
                          form.controls['maincategory']?.updateValue(val.lsfFacDesc);
                          context.read<LoanproductBloc>().add(
                                LoanProductDropdownChange(field: val),
                              );
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'subcategory',
                        label: 'Sub Category',
                        items: state.subCategoryList,
                        onChangeListener: (Product val) {
                          form.controls['subcategory']?.updateValue(val.lsfFacDesc);
                          context.read<LoanproductBloc>().add(
                                LoanProductDropdownChange(field: val),
                              );
                        },
                      ),
                      const SizedBox(height: 16),
                      state.selectedProduct != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: InfoCardWidget(
                                card: buildInfoCardFromProduct(state.selectedProduct!),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('No product selected'),
                            ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 3, 9, 110),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (form.valid) {
                              final tabController = DefaultTabController.of(context);
                              if (tabController.index < tabController.length - 1) {
                                tabController.animateTo(tabController.index + 1);
                              }
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
