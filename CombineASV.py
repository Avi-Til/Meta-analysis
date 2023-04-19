import pandas
import os
os.chdir('/scratch/bell/avijiela/Project/QIIME')
accList=open('BioProjList.txt', 'r').read().split()
for n, accID in enumerate(accList):
    print(f"Loop number:{n}; Accession ID:{accID}")
    if n == 0:
        CombinedASVTable=pandas.read_table(f'{accID}/{accID}.tsv')
    else:
        print("Merging Dataframe...")
        CombinedASVTable=pandas.merge(CombinedASVTable, pandas.read_table(f'{accID}/{accID}.tsv'), how='outer', on='#OTU ID')
        BlastDF=pandas.read_table(f'Blast/BlastOut/Blast{n}_20-100-240.out', header=None).iloc[:, [0,1]]
        BlastList=[BlastDF.columns.values.tolist()] + BlastDF.values.tolist()
        del BlastList[0]
        print("Replacing ASV IDs...")
        CombinedASVTable.replace(to_replace=[i[0] for i in BlastList], value=[i[1] for i in BlastList], inplace=True)
print("Grouping ASV IDs...")
print("Number of ASVs before grouping", CombinedASVTable.shape[0])
CombinedASVTable=CombinedASVTable.groupby(by=['#OTU ID']).sum()
print("Number of ASVs after grouping", CombinedASVTable.shape[0])
print("Writing to file...")
CombinedASVTable.to_csv('CombinedASVTable.tsv', sep="\t")
