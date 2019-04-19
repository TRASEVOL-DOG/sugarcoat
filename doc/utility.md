## `sugar. utility`

- Contents:
  - [`using_package(p, do_override)`](#sugarutility-using_package-p-do_override)
  - [`all(ar)`](#sugarutility-all-ar)
  - [`del(ar, val)`](#sugarutility-del-ar-val)
  - [`del_at(ar, n)`](#sugarutility-del_at-ar-n)
  - [`add(ar, v)`](#sugarutility-add-ar-v)
  - [`sort(ar)`](#sugarutility-sort-ar)
  - [`merge_tables(dst, src)`](#sugarutility-merge_tables-dst-src)
  - [`copy_table(tab, deep)`](#sugarutility-copy_table-tab-deep)

&#8202;

#### `sugar.utility. using_package(p, [do_override])`
- Makes all contents of the table `p` global.
- Useful to make a package's features more accessible.
- If `do_override` is true, this function will override existing global values if there are any. Otherwise, it will not.

&#8202;

#### `sugar.utility. all(ar)`
- To use with `for` to iterate through the elements of the ordered table `ar`.
- e.g:
```lua
local tab = {1, 2, 3}
for n in all(tab) do
  print(n)
end
-- > 1   2   3
```

&#8202;

#### `sugar.utility. del(ar, val)`
- Finds and removes the first occurence of `val` in the ordered table `ar`.
- If `ar` does not contain `val`, nothing happens.

&#8202;

#### `sugar.utility. del_at(ar, n)`
- Removes the item at position `n` in the ordered table `ar`.

&#8202;

#### `sugar.utility. add(ar, v)`
- Adds the item `v` to the end of the ordered table `ar`.

&#8202;

#### `sugar.utility. sort(ar)`
- Sorts the ordered table `ar`.

&#8202;

#### `sugar.utility. merge_tables(dst, src)`
- Copies all the keys from the table `src` into the table `dst`.
- Returns `dst`.

&#8202;

#### `sugar.utility. copy_table(tab, [deep])`
- Returns a copy of the table `tab`.
- If `deep` is `true`, the copy will have copies of any tables found inside `tab` and so will those.
- /!\ Avoid setting `deep` to `true` when operating on tables linking to other tables in your structure, especially if you're working with double-linked tables, as that would create an infinite loop.