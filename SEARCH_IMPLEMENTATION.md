# Search Implementation Documentation

## Overview
This document describes the dual-search functionality implemented in the SGMC Flutter App following Clean Architecture principles and BLoC pattern.

## Architecture

### 1. Repository Layer (`ServiceRepository`)
**File**: `lib/data/repositories/service_repository.dart`

**Method**: `searchItems()`
```dart
List<ItemModel> searchItems({
  required List<ItemModel> items,
  required String query,
}) {
  if (query.trim().isEmpty) return items;
  
  final q = query.toLowerCase().trim();
  
  return items.where((item) {
    return item.name.toLowerCase().contains(q) ||
        item.specialty.toLowerCase().contains(q) ||
        item.city.toLowerCase().contains(q) ||
        item.governorate.toLowerCase().contains(q);
  }).toList();
}
```

**Behavior**:
- Returns all items when query is empty
- Case-insensitive search
- Searches across: provider name, specialty, city, governorate

---

### 2. Cubit Layer (`ServiceCubit`)
**File**: `lib/logic/cubits/service/cubit/service_cubit.dart`

#### Method 1: `searchInAllData(String query)`
**Purpose**: Global search across entire dataset (HomeScreen)

**Behavior**:
- Searches ALL items regardless of current selection
- Empty query → clears `homeSearchResults` (shows governorates list)
- Non-empty query → populates `homeSearchResults`
- Does NOT reset governorate/category selections
- Does NOT trigger loading state

**State Updates**:
```dart
ServiceLoaded(
  items: current.items,           // Unchanged
  governorates: current.governorates,  // Unchanged
  providerTypes: current.providerTypes,  // Unchanged
  homeSearchResults: results,     // ✅ Updated
  selectedGovernorate: current.selectedGovernorate,  // Preserved
  selectedProviderType: current.selectedProviderType,  // Preserved
  filteredItems: current.filteredItems,  // Preserved
  groupedItemsByArea: current.groupedItemsByArea,  // Preserved
)
```

#### Method 2: `searchInCategory(String query)`
**Purpose**: Scoped search within selected category (ItemsScreen)

**Behavior**:
- Searches ONLY within `filteredItems` (current category)
- Empty query → restores original grouping
- Non-empty query → updates `groupedItemsByArea` with search results
- Preserves area grouping in results
- Does NOT affect HomeScreen state

**State Updates**:
```dart
ServiceLoaded(
  items: current.items,           // Unchanged
  governorates: current.governorates,  // Unchanged
  providerTypes: current.providerTypes,  // Unchanged
  selectedGovernorate: current.selectedGovernorate,  // Unchanged
  selectedProviderType: current.selectedProviderType,  // Unchanged
  filteredItems: current.filteredItems,  // Unchanged (original data preserved)
  groupedItemsByArea: newGrouped,  // ✅ Updated with search results
  homeSearchResults: current.homeSearchResults,  // Preserved
)
```

---

### 3. State Layer (`ServiceState`)
**File**: `lib/logic/cubits/service/cubit/service_state.dart`

**Key Fields**:
- `homeSearchResults: List<ItemModel>?` → Used by HomeScreen global search
- `groupedItemsByArea: Map<String, List<ItemModel>>?` → Used by ItemsScreen scoped search

**Equatable Props**:
```dart
@override
List<Object?> get props => [
  items,
  governorates,
  providerTypes,
  selectedGovernorate,
  selectedProviderType,
  filteredItems,
  groupedItemsByArea,
  homeSearchResults,  // ✅ Enables proper state comparison
];
```

---

## UI Implementation

### HomeScreen (Global Search)
**File**: `lib/presentation/screens/home_screen.dart`

**Features**:
1. **Search TextField**
   - Positioned below header, above content
   - Placeholder: "Search providers, specialties, areas..."
   - `onChanged` → calls `cubit.searchInAllData(query)`

2. **Dynamic Content Display**
   ```dart
   final isSearching = state.homeSearchResults != null;
   
   Expanded(
     child: isSearching
         ? _buildSearchResults(context, displayItems ?? [])
         : _buildGovernoratesList(context, state),
   )
   ```

3. **Search Results Display**
   - Shows provider name as title
   - Shows "specialty • city, governorate" as subtitle
   - Tapping result:
     1. Calls `cubit.selectGovernorate(item.governorate)`
     2. Calls `cubit.selectProviderType(item.providerType)`
     3. Navigates directly to `ItemsScreen`
   - Empty results → shows "No Results Found" empty state

4. **Governorates List** (default view when not searching)
   - Standard list of governorates
   - Navigation via BlocListener (existing flow)

---

### ItemsScreen (Scoped Search)
**File**: `lib/presentation/screens/items_screen.dart`

**Features**:
1. **Search TextField**
   - Positioned at top of screen
   - Placeholder: "Search in this category..."
   - `onChanged` → calls `cubit.searchInCategory(query)`

2. **Grouped Results Display**
   ```dart
   Column(
     children: [
       // Search bar
       Padding(...TextField...),
       
       // Results grouped by area
       Expanded(
         child: ListView(
           children: grouped.entries.map((entry) {
             return _AreaSection(
               areaName: entry.key,
               items: entry.value,
             );
           }).toList(),
         ),
       ),
     ],
   )
   ```

3. **Live Search**
   - Results update as user types
   - Area grouping preserved in search results
   - Empty query → restores original grouped data

---

## Search Flow Examples

### Example 1: Global Search
```
User Action: Types "cardiology" in HomeScreen search
↓
Cubit: searchInAllData("cardiology")
↓
Repository: searchItems(items: all items, query: "cardiology")
↓
State: homeSearchResults = [matching items]
↓
UI: Displays list of cardiologists across all governorates
↓
User taps result
↓
Navigation: HomeScreen → ItemsScreen (direct)
```

### Example 2: Scoped Search
```
User Action: Selects "Alexandria" → "Hospitals"
↓
ItemsScreen: Displays hospitals in Alexandria grouped by area
↓
User Action: Types "emergency" in ItemsScreen search
↓
Cubit: searchInCategory("emergency")
↓
Repository: searchItems(items: filteredItems, query: "emergency")
↓
State: groupedItemsByArea = {area1: [results], area2: [results]}
↓
UI: Displays hospitals with emergency services, still grouped by area
↓
User Action: Clears search
↓
UI: Restores original grouped display
```

---

## Key Design Decisions

### ✅ DO:
- Search is reactive (updates on each keystroke)
- Empty query restores original state
- Global search does NOT reset selections
- Scoped search preserves area grouping
- No loading states during search (instant)
- Use existing data in memory (no API calls)

### ❌ DON'T:
- Call `loadData()` during search
- Emit `ServiceLoading` state during search
- Mutate original lists
- Reset selections unnecessarily
- Mix search results from different contexts

---

## Testing Checklist

### HomeScreen Global Search
- [ ] Empty search shows governorates list
- [ ] Typing query shows search results
- [ ] Results include providers from all governorates
- [ ] Tapping result navigates to ItemsScreen with correct context
- [ ] Search works across: provider name, specialty, city, governorate
- [ ] Clearing search restores governorates list
- [ ] No "No Results Found" when search is empty

### ItemsScreen Scoped Search
- [ ] Shows all items grouped by area initially
- [ ] Typing query filters items
- [ ] Results maintain area grouping
- [ ] Search only includes items from current category
- [ ] Clearing search restores original grouped list
- [ ] Empty results shows appropriate empty state

### State Management
- [ ] No loading indicators during search
- [ ] Global search doesn't affect ItemsScreen
- [ ] Scoped search doesn't affect HomeScreen
- [ ] Selections preserved during global search
- [ ] BlocListener navigation still works for governorate selection

---

## Code Quality

### Architecture Compliance
✅ Repository handles filtering logic  
✅ Cubit coordinates state changes  
✅ UI only reacts to state  
✅ No setState used  
✅ Clean separation of concerns  

### Performance
✅ Search executes in memory (fast)  
✅ No unnecessary state emissions  
✅ Efficient list filtering  
✅ No API calls during search  

### User Experience
✅ Instant feedback  
✅ Clear empty states  
✅ Preserved context during navigation  
✅ Intuitive search behavior  

---

## Future Enhancements (Optional)

1. **Debouncing**: Add 300ms delay before search to reduce state emissions
2. **Search History**: Store recent searches locally
3. **Filters**: Add filters for governorate/category in global search
4. **Highlighting**: Highlight matching text in results
5. **Sort Options**: Sort results by relevance, distance, rating
6. **Voice Search**: Add speech-to-text for search input

---

## Related Files

- `lib/data/repositories/service_repository.dart` → Search logic
- `lib/logic/cubits/service/cubit/service_cubit.dart` → State coordination
- `lib/logic/cubits/service/cubit/service_state.dart` → State definition
- `lib/presentation/screens/home_screen.dart` → Global search UI
- `lib/presentation/screens/items_screen.dart` → Scoped search UI
- `lib/presentation/widgets/app_widgets.dart` → Reusable components

---

**Last Updated**: January 8, 2026  
**Implementation Status**: ✅ Complete  
**Tested**: ⏳ Pending manual testing
