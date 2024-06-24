
		public string palabra="", definicion = "";
		bool comp = false;
	   
		private void ComprobarYSiguiente(object sender, EventArgs e)
		{

			if (comp == false)
			{
				if (textBox1.Text == palabra)
				{
					correctAnswers++;
					textBox1.BackColor = Color.DarkGreen;
				}
				else
				{
					//textBox1.BackColor = Color.DarkRed;
					wrongAnswers++;
					
				}
				reachedAnswers++;
				label3.Text = Convert.ToString(correctAnswers);
				label4.Text = Convert.ToString(wrongAnswers);
				label1.Text = Convert.ToString(correctAnswers) + "/" + Convert.ToString(numberOfWords);
				progressBar1.Value = reachedAnswers;
				answer();
				textBox1.Text = "";
				comp = true;

			}
		}


	}
}
