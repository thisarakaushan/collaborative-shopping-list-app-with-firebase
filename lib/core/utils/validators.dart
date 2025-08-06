class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  static String? validateInviteCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invite code is required';
    }
    if (value.trim().length != 6) {
      return 'Invite code must be 6 characters';
    }
    return null;
  }

  static String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Quantity must be a positive number';
    }
    return null;
  }
}