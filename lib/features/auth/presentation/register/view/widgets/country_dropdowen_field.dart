import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../domain/entities/country.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_intents.dart';
import '../../manager/register_state.dart';

class CountryDropdownField extends StatelessWidget {
  const CountryDropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
      previous.countriesResource != current.countriesResource ||
          previous.selectedCountry != current.selectedCountry,
      builder: (context, state) {
        final countries = state.countriesResource.data ?? [];
        return DropdownButtonFormField<Country>(
          value: state.selectedCountry,
          decoration: InputDecoration(
            labelText: LocaleKeys.apply_country_label.tr(),
          ),
          items: countries.map((c) {
            return DropdownMenuItem<Country>(
              value: c,
              child: Row(
                children: [
                  Text(c.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(c.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (c) {
            if (c != null) {
              context.read<RegisterCubit>().onIntent(SelectCountryIntent(c));
            }
          },
        );
      },
    );
  }
}