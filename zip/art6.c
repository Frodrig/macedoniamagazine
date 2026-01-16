/* Ejemplo sobre transformaciones afines con OpenGL para
   Macedonia Magazine'99.

   por Oscar García Panyella.
*/

#include <GL/glut.h>

#define WIDTH 200		/* Ancho ventanas en pixels */
#define HEIGHT 200		/* Alto ventanas en pixels */

typedef GLfloat punto[3];

punto cubo[8]={{-10.0,0.0,10.0},{10.0,0.0,10.0},{10.0,0.0,-10.0},
{-10.0,0.0,-10.0},{-10.0,10.0,10.0},{10.0,10.0,10.0},{10.0,10.0,-10.0},
{-10.0,10.0,-10.0}};

/*********************************************************************/

/* SECCIÓN DE DISPLAY */

/* Dibuja la cara que recibe */
void cara(GLint a, GLint b, GLint c, GLint d){
	glBegin(GL_POLYGON);
		glVertex3fv(cubo[a]);
		glVertex3fv(cubo[b]);
		glVertex3fv(cubo[c]);
		glVertex3fv(cubo[d]);
	glEnd();
}

/* Dibuja un cubo */
void objeto(void){

	glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	
	cara(0,1,5,4);
	cara(1,2,6,5);
	cara(2,3,7,6);
	cara(0,4,7,3);
	cara(4,5,6,7);
	cara(0,3,2,1);
}

/* Dibuja los ejes de referencia */
void ejes(void){
	glBegin(GL_LINES);
		glVertex3i(0,0,0);
		glVertex3i(0,40,0);

		glVertex3i(0,0,0);
		glVertex3i(40,0,0);

		glVertex3i(0,0,0);
		glVertex3i(0,0,40);
	glEnd();
}

/* Render de la ventana 1 */
void display1(void){
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glColor3f(1.0,1.0,0.0);
	ejes();

	glColor3f(1.0,0.0,0.0);
	
	objeto();
	
	glColor3f(0.0,1.0,0.0);

	glPushMatrix();
	  glScalef(2.0,2.0,2.0);
	  objeto();
	glPopMatrix();

	glutSwapBuffers();
}

/* Render de la ventana 2 */
void display2(void){
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor3f(1.0,1.0,0.0);
	ejes();

	glColor3f(1.0,0.0,0.0);
	
	objeto();

	glColor3f(0.0,1.0,0.0);

	glPushMatrix();
	  glTranslatef(30.0,0.0,0.0);
	  objeto();
	glPopMatrix();

	glutSwapBuffers();
}

/* Render de la ventana 3 */
void display3(void){
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor3f(1.0,1.0,0.0);
	ejes();

	glColor3f(1.0,0.0,0.0);
	
	objeto();

	glColor3f(0.0,1.0,0.0);

	glPushMatrix();
	  glRotatef(45.0,0,1,0);
	  objeto();
	glPopMatrix();

	glutSwapBuffers();
}

/* Render de la ventana 4 */
void display4(void){
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor3f(1.0,1.0,0.0);
	ejes();

	glColor3f(1.0,0.0,0.0);
	
	objeto();

	glColor3f(0.0,1.0,0.0);

	glPushMatrix();
	  glRotatef(45.0,0,1,0);
	  glTranslatef(30.0,0.0,0.0);
	  objeto();
	glPopMatrix();

	glutSwapBuffers();
}

/* Render de la ventana 5 */
void display5(void){
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glColor3f(1.0,1.0,0.0);
	ejes();

	glColor3f(1.0,0.0,0.0);
	
	objeto();

	glColor3f(0.0,1.0,0.0);

	glPushMatrix();
	  glTranslatef(30.0,0.0,0.0);
	  glRotatef(45.0,0,1,0);
	  objeto();
	glPopMatrix();

	glutSwapBuffers();
}

/*********************************************************************/

/* VISIÓN e INICIALIZACIÓN */

/* Proyección ortográfica asociada a las 5 ventanas */
/* Una vez creada la proyección activamos e inicializamos la
matriz de transformación - GL_MODELVIEW */
/* ¿Por qué crees que tras inicializar añado 2 transformaciones que afectarán
a toda la geometría? */
void ini(void){
  glClearColor(0.0, 0.0, 0.0, 1.0);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-50.0,50.0,-50.0,50.0,-50.0,50.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0.0,-10.0,0.0);
  glRotatef(45.0, 1.0, 1.0, 1.0);
}

/*********************************************************************/

/* MAIN */

int main(int argc, char** argv){
	
	glutInit(&argc, argv);
	
	glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	
	/* Definición ventana 1 */
	
	glutInitWindowSize (WIDTH, HEIGHT);
	
	glutInitWindowPosition (0, 0);
	
	glutCreateWindow("MM: Escalar");
	
	glutDisplayFunc(display1);
	
	ini();

	/* Definición ventana 2 */
	
	glutInitWindowSize (WIDTH, HEIGHT);
	
	glutInitWindowPosition (250, 0);
	
	glutCreateWindow("MM: Trasladar");
	
	glutDisplayFunc(display2);
	
	ini();

	/* Definición ventana 3 */
	
	glutInitWindowSize (WIDTH, HEIGHT);
	
	glutInitWindowPosition (500, 0);
	
	glutCreateWindow("MM: Rotar");
	
	glutDisplayFunc(display3);
	
	ini();

	/* Definición ventana 4 */
	
	glutInitWindowSize (WIDTH, HEIGHT);
	
	glutInitWindowPosition (75, 275);
	
	glutCreateWindow("MM: Rotar+Trasladar");
	
	glutDisplayFunc(display4);
	
	ini();

	/* Definición ventana 5 */
	
	glutInitWindowSize (WIDTH, HEIGHT);
	
	glutInitWindowPosition (425, 275);
	
	glutCreateWindow("MM: Trasladar+Rotar");
	
	glutDisplayFunc(display5);
	
	ini();

	glutMainLoop();
	return 0;   
}








