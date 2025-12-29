# Dynamic Form Implementation Guide for JLG, SHG, and Other Products

## Overview
This guide explains how the new dynamic form system works for different product types (JLG, SHG, Other) in the NewsEE application.

## Changes Made

### 1. **New Form Builders** (`lib/AppData/form_builders.dart`)
Created separate form builders for each product type:
- `buildSHGForm()` - For Self-Help Group products
- `buildJLGForm()` - For Joint Liability Group products
- `buildOtherForm()` - For other product types

**Key Features:**
- Each form has product-specific fields
- Common base fields are reused across all forms
- Product-specific validation rules

### 2. **Enhanced SchemeState** (`lib/feature/schemes/scheme_state.dart`)
Updated to include:
- `dynamicForm: FormGroup?` - The actual form instance for current scheme
- `formType: String` - Tracks which form is active (SHG, JLG, OTHER)
- `schemeLabel` getter - Returns user-friendly labels

### 3. **New SchemeEvents** (`lib/feature/schemes/scheme_event.dart`)
Added:
- `InitializeSchemeFormEvent` - Automatically creates appropriate form when scheme is selected

### 4. **Enhanced SchemeBloc** (`lib/feature/schemes/scheme_bloc.dart`)
Now handles:
- Automatic form creation when scheme is selected
- Proper mapping of SchemeType to form labels
- Form state management

### 5. **Form Field Utilities** (`lib/AppData/scheme_form_field_utils.dart`)
Provides utility methods for:
- Getting visible fields per scheme
- Checking field visibility and mandatory status
- Managing field requirements

### 6. **Form Field Renderer** (`lib/feature/productform/presentation/widget/scheme_based_form_field_renderer.dart`)
Helper widget to:
- Render fields conditionally based on scheme type
- Show/hide fields with proper opacity handling
- Maintain consistent field rendering across forms

## Implementation in personal.dart

### Quick Implementation Steps:

#### Step 1: Import Required Classes
```dart
import 'package:newsee/feature/schemes/scheme_bloc.dart';
import 'package:newsee/feature/schemes/scheme_state.dart';
import 'package:newsee/feature/schemes/scheme_type.dart';
import 'package:newsee/AppData/form_builders.dart';
import 'package:newsee/feature/productform/presentation/widget/scheme_based_form_field_renderer.dart';
```

#### Step 2: Use Dynamic Form Instead of Static Form
```dart
class Personal extends StatelessWidget {
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchemeBloc, SchemeState>(
      builder: (context, schemeState) {
        // Use the form from SchemeBloc instead of static AppForms
        final FormGroup form = schemeState.dynamicForm ?? 
          AppForms.GET_PERSONAL_DETAILS_FORM();
        
        return ReactiveForm(
          formGroup: form,
          child: // ... form content ...
        );
      },
    );
  }
}
```

#### Step 3: Conditionally Render Fields Based on Scheme
```dart
// Instead of rendering all fields, render based on scheme
final schemeType = schemeState.selectedScheme;

// Render agriculturistType field only for JLG and Other
if (SchemeFormFieldUtils.isFieldVisibleForScheme('agriculturistType', schemeType)) {
  SchemeBasedFormFieldRenderer.buildAgriculturistTypeField(
    fieldKey: _agriculturistTypeKey,
    lovList: state.lovList!,
    form: form,
    schemeType: schemeType,
  ),
}

// Render gender field only for JLG and Other
if (SchemeFormFieldUtils.isFieldVisibleForScheme('gender', schemeType)) {
  SchemeBasedFormFieldRenderer.buildGenderField(
    fieldKey: _genderKey,
    lovList: state.lovList!,
    form: form,
    schemeType: schemeType,
  ),
}
```

## Form Field Differences

### SHG (Self-Help Group)
**Visible Fields:**
- Title, First Name, Middle Name, Last Name
- DOB, Residential Status
- Primary & Secondary Mobile Numbers
- Email, Aadhaar, PAN
- Loan Amount Requested
- Purpose of Loan (Nature of Activity)
- Occupation Type
- Sub Activity
- SHG-specific fields: Group Name, Member Count, Registration Number, Registration Date

**NOT Visible:**
- Religion, Caste, Gender
- Farmer Category, Farmer Type
- Agriculturist Type

### JLG (Joint Liability Group)
**Visible Fields:**
- Title, First Name, Middle Name, Last Name
- DOB, Residential Status
- Primary & Secondary Mobile Numbers
- Email, Aadhaar, PAN
- Loan Amount Requested
- Purpose of Loan
- Occupation Type
- Agriculturist Type
- Farmer Category, Farmer Type
- Religion, Caste, Gender
- JLG-specific fields: Group Name, Member Count, Registration Number, Registration Date

### Other Products
**Visible Fields:**
- All basic fields
- Purpose of Loan
- Occupation Type
- Agriculturist Type
- Farmer Category, Farmer Type
- Religion, Caste, Gender
- Sub Activity

**NOT Visible:**
- Group-specific fields (SHG/JLG)

## Usage Example

```dart
// In your personal.dart file
BlocBuilder<SchemeBloc, SchemeState>(
  builder: (context, schemeState) {
    final FormGroup form = schemeState.dynamicForm ?? 
      FormBuilders.getFormForScheme(schemeState.formType);
    
    return ReactiveForm(
      formGroup: form,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Common fields for all schemes
              SearchableDropdown(
                controlName: 'title',
                label: 'Title',
                // ... rest of configuration
              ),
              
              // Conditionally render scheme-specific fields
              if (SchemeFormFieldUtils.isFieldVisibleForScheme(
                'agriculturistType',
                schemeState.selectedScheme,
              ))
                SchemeBasedFormFieldRenderer.buildAgriculturistTypeField(
                  fieldKey: _agriculturistTypeKey,
                  lovList: state.lovList!,
                  form: form,
                  schemeType: schemeState.selectedScheme,
                ),
              
              // More fields...
            ],
          ),
        ),
      ),
    );
  },
);
```

## Benefits

1. **Dynamic Form Creation** - Forms are created based on selected product type
2. **Cleaner Code** - No need for complex conditional rendering of all fields
3. **Type Safety** - SchemeType enum ensures correct scheme selection
4. **Reusable** - Form builders can be used across different pages
5. **Maintainable** - Easy to add new fields or modify existing ones per scheme
6. **Validation Control** - Different validation rules per scheme type

## Testing Checklist

- [ ] Select SHG - verify only SHG fields appear
- [ ] Select JLG - verify only JLG fields appear
- [ ] Select Other - verify appropriate fields appear
- [ ] Switch between schemes - form fields update correctly
- [ ] Form validation works per scheme
- [ ] Form submission captures correct fields per scheme
- [ ] Existing lead data populates correctly per scheme

## Notes

- The form is now managed by SchemeBloc instead of being static in AppForms
- FormGroups are created on-demand when scheme is selected
- Field visibility is controlled by SchemeFormFieldUtils
- All field rendering is handled by SchemeBasedFormFieldRenderer for consistency
