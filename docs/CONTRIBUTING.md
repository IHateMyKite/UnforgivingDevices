# Contributing guideline

## ====Papyrus syntax====

Because most of this mod is written in papyrus, all new PR should from now use the following syntax, to make the project more consistent.

### ---Function arguments---

All function arguments should use the following template

> Type aXVarName

Where a is short for argument, and should always be present, as it is also the same syntax used by native skyrim functions
Where X is short for variable type

- **f** for float
- **i** for int
- **s** for string
- **k** for object (any kind of form, like actor, weapon, armor etc..)
- **a** for array

**Example**

```
Int Function Fun(Int aiArg1, Float afArg2, String[] aaSomeOtherArg3, ....)
```

### ---Function names---

The function name should at least to some extent explain what it is for
In case that function should be used as private one, and not as public one, it should be prefixed with underscore **\_**
All non-private function should also have provided comment block above which explain what is function for

**Example**
```
;This function will damage player health by afDamage. By default this can't kill player, unless argument abCanKill is set as true
Function DamagePlayer(Float afDamage, Bool abCanKill = False)
```

### ---Variables---

There are 2 kind of variables, private ones, and local ones
Private variables are defined not in function but on the script itself. Variables like this should be again prefixed with **\_**
Local variables should be prefixed with keyword **loc\_**.
In both cases, variable type is not required, but can be provided.
Documentation is not required, but can be provided.

**Example**

```
    Int _TimesCalles = 0  
    Function SomeFuntion()  
      Int loc_TimesCalled = _TimesCalles  
      loc_TimesCalled += 1  
      _TimesCalles = loc_TimesCalled  
    EndFunction 
```

### ---Properties---

Like with variables, there are 2 kinds, public and private property
All public properties should start with suffix UD or UDG in case of global variable. They also have to be documented with comment
Private properties should again be prefixed with **\_**. They also need to have keyword **Hidden** after them.

```
    ;This property can be edited to change mod update time
    Int Property UD_UpdateTime = 10 auto
    
    String Property _PlayerName = "Player" auto Hidden
```

## ====Testing and Review====

This section talks about how should be PR tested before merge and how review should be done

### ---Testing---

- All sources need to be compiled without error. You can use PCA for that.
- All implemented changes should be at least once tested in-game. No advanced testing is needed, as that is what review is for.
- Before Review, contributor should provide full list of all changes which are implemented in PR

### ---Review---

All PR should have at least one review before being allowed to be merged. Review should be done by checking the following checklist. Review is done once all points are successful

***First part - Pre in game testing***

[ ] All Source scripts can be compiled without issue    
[ ] All Papyrus scripts are using correct Papyrus syntax which is in Contributing guideline    
[ ] All ESP related changes are in a separate esp patch file, named PRXXX_Name, where XXX is PR number and Name is custom PR name    

***Second part - In game testing***

[ ] All main PR changes should be tested at least once. Only changes provided by contributor should be tested by reviewer.    
[ ] UD should load correctly after **loading existing save**. Recommended creating new game before starting the review.    
[ ] UD should load correctly after **making new game** (can be tested by opening MCM and player menu)    

**Last part - Analyze**

[ ] The code is optimized and doesn't contain parts which can decrease mod stability    

### ---Exeptions---
All PRs which were started before 04.01.2023
