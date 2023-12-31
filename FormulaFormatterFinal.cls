//Created by Damiano Strano and Mario Nicolosi on 06/11/2023.

public with sharing class FormulaFormatterFinal {

    @AuraEnabled
    public static String getFormula(String formula){
        System.debug('[APEX] FormulaFormatter getFormula [START]');

        List<Integer> integerList = FormulaFormatterFinal.AscendedSortFormula(formula);
        System.debug(integerList);
        String value = formula;
        Integer counter = 0;
        Boolean firstTime = true;
        String tab = '';
        Boolean lastCharacterNot = false;

        if(integerList.isEmpty()){
            List<Integer> integerListConv = FormulaFormatterFinal.AscendedSortFormulaConverted(formula);
            System.debug(integerListConv);
            Integer valueInteger = 0;

            for(Integer i = 0; i < integerListConv.size(); i++){

                if(!firstTime){
                    tab += '    ';
                    formula = formula.removeEnd(')');
                    valueInteger++;
                }

                if(value.substring(integerListConv[i]).startsWith('AND')){
                    if(firstTime){
                        formula = 'and(' + formula.substring(integerListConv[i]).substringAfter('AND(');
                    }
                    else{
                        formula = formula.substringBefore('AND(') + '\n' + tab+ 'and(' + formula.substring(integerListConv[i]).substringAfter('AND(');
                    }
                }
                if(value.substring(integerListConv[i]).startsWith('OR')){
                    if(firstTime){
                        formula = 'or(' + formula.substring(integerListConv[i]).substringAfter('OR(');
                    }
                    else{
                        formula = formula.substringBefore('OR(') + '\n' + tab+ 'or(' + formula.substring(integerListConv[i]).substringAfter('OR(');
                    }
                }
                if(value.substring(integerListConv[i]).startsWith('NOT')){
                    if(firstTime){
                        formula = 'not(' + formula.substring(integerListConv[i]).substringAfter('NOT(');
                    }
                    else{
                        formula = formula.substringBefore('NOT(') + '\n' + tab+ 'not(' + formula.substring(integerListConv[i]).substringAfter('NOT(');
                    }
                }

                firstTime = false;
            }

            if(formula.contains('not')){
                formula = formula.replace('not','NOT');
            }
            if(formula.contains('or')){
                formula = formula.replace('or','OR');
            }
            if(formula.contains('and')){
                formula = formula.replace('and','AND');
            }

            for (Integer i=0; i < valueInteger; i++){
                tab = tab.removeEnd('    ');
                formula += '\n'+tab+')';
            }
        }
        else{
            for(Integer i = 0; i < integerList.size(); i++){

                Integer x = 0;
                Boolean isNot = true;
                tab += '    ';

                if (i <= integerList.size() - 2) {
                    x = i + 1;
                }
                else{
                    x = integerList.size()-1;
                }

                if(value.substring(integerList[i]).startsWith('&&')){
                    counter++;
                    if(firstTime){
                        formula = 'AND(';
                        if(value.substring(integerList[x]).startsWith('!')){
                            isNot = false;
                            formula += value.substringBefore('&&') +','+ value.substring(integerList[i]).substringAfter('&&');
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            formula += value.substringBefore('&&') +',\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('&&','||') +','+ value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('&&')){
                            formula += value.substringBefore('&&') +',\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('&&','&&') +','+ value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('&&') && !value.substring(integerList[x]).startsWith('!') && !value.substring(integerList[x]).startsWith('||')){
                            formula += value.substringBefore('&&') +','+ value.substring(integerList[i]).substringAfter('&&');
                            break;
                        }
                    }
                    else{
                        formula = formula.substringBefore('&&') + '\n' + tab + 'AND(';
                        if(value.substring(integerList[x]).startsWith('!')){
                            isNot = false;
                            formula += value.substringBefore('&&') +','+ value.substring(integerList[i]).substringAfter('&&');
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            tab += '    ';
                            formula += value.substringBefore('&&') +',\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('&&','||') +','+ value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('&&')){
                            tab += '    ';
                            formula += value.substringBefore('&&') +',\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('&&','&&') +','+ value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('&&') && !value.substring(integerList[x]).startsWith('!') && !value.substring(integerList[x]).startsWith('||')){
                            formula += value.substringBefore('&&') +','+ value.substring(integerList[i]).substringAfter('&&');
                            break;
                        }
                    }
                }
                if(value.substring(integerList[i]).startsWith('||')){
                    counter++;
                    if(firstTime){
                        formula = 'OR(';
                        if(value.substring(integerList[x]).startsWith('!')){
                            isNot = false;
                            formula += value.substringBefore('||') +','+ value.substring(integerList[i]).substringAfter('||');
                        }
                        if(value.substring(integerList[x]).startsWith('&&')){
                            formula += value.substringBefore('||') +',\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('||','&&') +','+ value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            formula += value.substringBefore('||') +',\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('||','||') +','+ value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('||') && !value.substring(integerList[x]).startsWith('!') && !value.substring(integerList[x]).startsWith('&&')){
                            formula += value.substringBefore('||') +','+ value.substring(integerList[i]).substringAfter('||');
                            break;
                        }
                    }
                    else{
                        formula = formula.substringBefore('||') + '\n' + tab + ' OR(';
                        if(value.substring(integerList[x]).startsWith('!')){
                            isNot = false;
                            formula += value.substringBefore('||') +','+ value.substring(integerList[i]).substringAfter('||');
                        }
                        if(value.substring(integerList[x]).startsWith('&&')){
                            tab += '    ';
                            formula += value.substringBefore('||') +',\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('||','&&') +','+ value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            tab += '    ';
                            formula += value.substringBefore('||') +',\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('||','||') +','+ value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('||') && !value.substring(integerList[x]).startsWith('!') && !value.substring(integerList[x]).startsWith('&&')){
                            formula += value.substringBefore('||') +','+ value.substring(integerList[i]).substringAfter('||');
                            break;
                        }
                    }
                }
                if(value.substring(integerList[i]).startsWith('!')){
                    if(firstTime){
                        formula = 'NOT(';
                        if(value.substring(integerList[x]).startsWith('&&')){
                            formula += '\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('!','&&').remove('[()]') + ',' + value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            formula += '\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('!','||').remove('[()]') + ',' + value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('&&') && !value.substring(integerList[x]).startsWith('||')){
                            formula += value.substring(integerList[i]).substringAfter('!');
                            lastCharacterNot = true;
                            break;
                        }
                    }
                    else{
                        formula = formula.substringBefore('!(') + '\n' + tab + 'NOT(';
                        if(value.substring(integerList[x]).startsWith('&&')){
                            tab += '    ';
                            formula += '\n' + tab + 'AND(' + value.substring(integerList[i]).substringBetween('!','&&').remove('[()]') + ',' + value.substring(integerList[x]).substringAfter('&&');
                            counter++;
                        }
                        if(value.substring(integerList[x]).startsWith('||')){
                            tab += '    ';
                            formula += '\n' + tab + 'OR(' + value.substring(integerList[i]).substringBetween('!','||').remove('[()]') + ',' + value.substring(integerList[x]).substringAfter('||');
                            counter++;
                        }
                        if(!value.substring(integerList[x]).startsWith('&&') && !value.substring(integerList[x]).startsWith('||')){
                            formula += value.substring(integerList[i]).substringAfter('!').remove('(');
                            lastCharacterNot = true;
                            break;
                        }
                    }
                }

                firstTime = false;
                if(isNot){
                    counter++;
                    i++;
                    isNot = true;
                }
            }

            firstTime = true;

            for (Integer i=0; i < counter; i++){

                if(!formula.endsWith(')') && firstTime){
                    counter--;
                    tab = tab.removeEnd('    ');
                    formula = formula +')';
                    firstTime = false;
                    continue;
                }
                else if(firstTime && formula.endsWith(')))')){
                    tab = tab.removeEnd('    ');
                    formula = formula.removeEnd('))')+ '\n'+ tab +')';
                    firstTime = false;
                    continue;
                }
                else if(lastCharacterNot && firstTime &&  formula.endsWith('))')){
                    tab = tab.removeEnd('    ');
                    formula = formula.removeEnd(')')+ '\n'+ tab +')';
                    firstTime = false;
                    continue;
                }
                else if(firstTime && formula.endsWith('))')){
                    counter--;
                    tab = tab.removeEnd('    ');
                    formula += '\n'+ tab +')';
                    firstTime = false;
                    continue;
                }
                tab = tab.removeEnd('    ');
                formula = formula + '\n'+ tab +')';
            }
        }

        System.debug(formula);
        System.debug('[APEX] FormulaFormatter getFormula [END]');
        return formula;
    }

    public static List<Integer> AscendedSortFormulaConverted(String formula){
        System.debug('[APEX] FormulaFormatter AscendedSortFormulaConverted [START]');

        List<Integer> integerList = new List<Integer>();

        for(Integer i = 0; i < formula.length(); i++){
            if(formula.substring(i).startsWith('AND')){
                integerList.add(formula.indexOf('AND',i));
                i = i + 3;
            }
            if(formula.substring(i).startsWith('OR')){
                integerList.add(formula.indexOf('OR',i));
                i = i + 2;
            }
            if(formula.substring(i).startsWith('NOT')){
                integerList.add(formula.indexOf('NOT',i));
                i = i + 3;
            }
        }
        System.debug('[APEX] FormulaFormatter AscendedSortFormulaConverted [END]');
        return integerList;
    }

    public static List<Integer> AscendedSortFormula(String formula){
        System.debug('[APEX] FormulaFormatter AscendedSortFormula [START]');

        List<Integer> integerList = new List<Integer>();

        for(Integer i = 0; i < formula.length(); i++){
            if(formula.substring(i).startsWith('&&')){
                integerList.add(formula.indexOf('&&',i));
                i = i + 2;
            }
            if(formula.substring(i).startsWith('||')){
                integerList.add(formula.indexOf('||',i));
                i = i + 2;
            }
            if(formula.substring(i).startsWith('!')){
                integerList.add(formula.indexOf('!',i));
                i++;
            }
        }
        System.debug('[APEX] FormulaFormatter AscendedSortFormula [END]');
        return integerList;
    }
}