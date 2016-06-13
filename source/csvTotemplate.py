import csv
import getopt
import os
import sys

_verbose = 0


def get_region(regIFA):
    map_file = open('./map.csv', 'rb')
    regions = csv.DictReader(map_file)
    for count in regions:
        if count['Region(IFA)'].strip() == regIFA:
            return count['Region(OCP)'].strip()
    return 'None'


def verbose(ImpCount, regIFA, regOCP, exCount, product, year, quarter, code, kt, aggflag):
    print('\033[1;32m' + str(ImpCount) + ',' + str(regIFA) + ',' + str(regOCP) + ',' + str(exCount) + ',' + str(
        product) + ',' + str(year) + ',' + str(quarter) + ',' + str(code) + ',' + str(
        kt) + ',' + 'P2O5' + ',' + 'Cumulated' + ',' + aggflag + '\033[1;m')


def P2O5_to_product(out_w, ImpCount, regIFA, regOCP, exCount, product, year, quarter, kt, aggflag):
    if product == 'MAP':
        if kt != '-':
            kt = '%.1f' % round(float(kt) / 0.52)
        code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
            year) + str(quarter) + 'Product'
        out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                        str(product).strip(), year.strip(), quarter.strip(), code, kt,
                        'Product', 'Cumulated', aggflag))

    elif product == 'DAP':
        if kt != '-':
            kt = '%.1f' % round(float(kt) / 0.46)
        code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
            year) + str(quarter) + 'Product'
        out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                        str(product).strip(), year.strip(), quarter.strip(), code, kt,
                        'Product', 'Cumulated', aggflag))

    elif product == 'TSP':
        if kt != '-':
            kt = '%.1f' % round(float(kt) / 0.46)
        code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
            year) + str(quarter) + 'Product'
        out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                        str(product).strip(), year.strip(), quarter.strip(), code, kt,
                        'Product', 'Cumulated', aggflag))

    elif product == 'PA':
        if kt != '-':
            kt = float(kt)
        code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
            year) + str(quarter) + 'Product'
        out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                        str(product).strip(), year.strip(), quarter.strip(), code, kt,
                        'Product', 'Cumulated', aggflag))

    elif product == 'Rock':
        if kt != '-':
            kt = '%.1f' % round(float(kt) / 0.30)
        code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
            year) + str(quarter) + 'Product'
        out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                        str(product).strip(), year.strip(), quarter.strip(), code, kt,
                        'Product', 'Cumulated', aggflag))


def main(argv):
    years_folder = ''
    try:
        opts, args = getopt.getopt(argv, "vf:", ["verbose", "folder="])
    except getopt.GetoptError:
        print("ERROR")
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-v', '--verbose'):
            global _verbose
            _verbose = 1
        if opt in ('-f', '--folder'):
            years_folder = arg
    years = os.listdir(years_folder)
    out = open('out.csv', 'wb')
    out_w = csv.writer(out)

    out_w.writerow(('Importing countries', 'Region (IFA)', 'Region (OCP)', 'Exporting countries', 'Product', 'Year',
                    'Quarter', 'Code', 'kT', 'P2O5/Product', 'Cumulated/Not Cumulated', 'AGG/DET/ANN'))
    for year in years:
        quarters = os.listdir(years_folder + '/' + year)
        for quarter in quarters:
            products = os.listdir(years_folder + '/' + year + '/' + quarter)
            for product in products:
                f = open(years_folder + '/' + year + '/' + quarter + '/' + product + '/EXPORTS/data.csv', 'rb')
                trades = csv.DictReader(f)
                aggflag = product.split('_')[1]
                product = product.split('_')[0]
                if product == 'MGA':
                    product = 'PA'
                regIFA = 'None'
                for trade in trades:
                    ImpCount = trade.get('Countries').strip()

                    for exCount in trade.keys():
                        if exCount not in ['Countries', 'T2014', 'T2013', 'T2012', 'T2015', 'T2016', 'T2017', 'T2018',
                                           'T2019', 'T2020']:
                            kt = str(trade.get(exCount)).replace(" ", "")
                            if kt == '':
                                regIFA = ImpCount
                                break
                            regOCP = get_region(regIFA)
                            if ImpCount != 'Subtotal' and 'total' not in ImpCount and "TOTAL" not in \
                                    ImpCount and 'variation' not in ImpCount and 'Total' not in ImpCount and \
                                            ImpCount != 'Various' and ImpCount != 'Others':
                                code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
                                    year) + str(quarter) + 'P2O5'
                                out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                                                str(product).strip(), year.strip(), quarter.strip(), code, kt,
                                                'P2O5', 'Cumulated', aggflag))
                                P2O5_to_product(out_w, ImpCount, regIFA, regOCP, exCount, product, year, quarter,
                                                kt, aggflag)
                                if _verbose == 1:
                                    verbose(ImpCount, regIFA, regOCP, exCount, product, year, quarter, code, kt,
                                            aggflag)

                            if ImpCount == 'Various':
                                ImpCount = ImpCount + ' ' + regIFA
                                code = str(ImpCount) + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
                                    year) + str(quarter) + 'P2O5'
                                out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                                                str(product).strip(), year.strip(), quarter.strip(), code, kt,
                                                'P2O5', 'Cumulated', aggflag))
                                P2O5_to_product(out_w, ImpCount, regIFA, regOCP, exCount, product, year, quarter,
                                                kt, aggflag)
                                if _verbose == 1:
                                    verbose(ImpCount, regIFA, regOCP, exCount, product, year, quarter, code, kt,
                                            aggflag)

                            if ImpCount == 'Others':
                                ImpCount = 'Various Others'
                                regIFA = 'Others'
                                regOCP = 'Others'
                                code = ImpCount + str(regIFA) + str(regOCP) + str(exCount) + str(product) + str(
                                    year) + str(quarter) + 'P2O5'
                                out_w.writerow((ImpCount, regIFA.strip(), regOCP.strip(), str(exCount).strip(),
                                                str(product).strip(), year.strip(), quarter.strip(), code, kt,
                                                'P2O5', 'Cumulated', aggflag))
                                P2O5_to_product(out_w, ImpCount, regIFA, regOCP, exCount, product, year, quarter,
                                                kt, aggflag)
                                if _verbose == 1:
                                    verbose(ImpCount, regIFA, regOCP, exCount, product, year, quarter, code, kt,
                                            aggflag)


if __name__ == '__main__':
    main(sys.argv[1:])
