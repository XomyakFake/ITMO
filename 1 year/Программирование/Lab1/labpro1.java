import java.util.Random;
public class labpro1 {
    public static final double E = Math.E;
    public static final int COUNT_COLUMNS = 20;
    public static final int COUNT_ROWS = 16;
    public static final int NUM_AFTER_POINT = 2;

    public static void main(String args[]){
        long[] l = new long[COUNT_ROWS];
        double[] x = new double[COUNT_COLUMNS];
        for(int i = 0;i < l.length;i++){
            l[i] = 19 - i;
        }
        double min = -10.0;
        double max = 5.0;
        Random rand = new Random();
        for(int i = 0;i<x.length;i++){
            x[i] = min + (max-min) * rand.nextDouble();
        }

        double[][] k = initMatrix(COUNT_ROWS,COUNT_COLUMNS,l,x);
        printMatrix(k,NUM_AFTER_POINT);
    }

    public static double[][] initMatrix(int rows, int columns, long[] l, double[] x){
        double[][] k = new double[rows][columns];
        for(int i = 0;i<rows;i++){
            for(int j = 0 ;j<columns;j++){
                k[i][j] = calculate(l[i], x[j]);
            }
        }    
        return k;
    }
    
    public static void printMatrix(double[][] matrix, int numbersafterpoint){
        for(double[] line : matrix){
        for(double item : line){
            System.out.printf("%." + numbersafterpoint + "f ", item);
        }
        System.out.println();
        }
    } 
    
    public static double calculate(long l, double x){
        if (l == 11){
            return Math.pow((Math.pow(E,Math.log(Math.abs(x)))),((Math.pow((2*Math.pow(E,(x))),3))/(Math.asin(Math.cos(x))-Math.PI)));
        }    
        if(l>=6 && l<=19){
            return Math.pow(Math.cos(Math.pow(Math.PI * x, 3)) * Math.asin(Math.pow((x - 2.5) / 15, 2) - 1), Math.log(Math.pow(Math.sin(x), 2)));
        }
        else{
            return Math.pow(E, Math.pow(0.5 * Math.tan(x), 3)) * (1 - Math.sin(Math.log(Math.abs(x))));
        }

    }
}
