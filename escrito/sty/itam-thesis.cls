% Class File para reproducir un estilo similar a los textbooks del Open Logic Project en 
% mi tesis

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{itam-thesis}[2020/12/28 Clase de Tesis ITAM estilo Open Logic]

% Clases requeridas
\RequirePackage{graphicx}
% \RequirePackage[local]{gitinfo2} % Poder añadir git revision hash

% Extendiendo clase memoir
\LoadClass[11pt,openany]{memoir}

% Renovando comando de hacer titulo para hacerlo estilo tesis
\renewcommand{\maketitle}{%
	\begin{center}
	\textsc{\Large Instituto Tecnológico Autónomo de México}\\[2em]

	% Logo ITAM
	\begin{figure}[h]
	\begin{center}
	\includegraphics[scale=0.50]{img/logo-ITAM.pdf}
	\end{center}
	\end{figure}

	\textbf{\LARGE \@title }\\[2em]

	\textsc{\large Tesis}\\[1em]

	\textsc{\large que para obtener el título de}\\[1em]

	\textsc{\LARGE Licenciado en Matemáticas Aplicadas}\\[1em]

	\textsc{\large Presenta}\\[1em]

	\textsc{\LARGE \@author}\\[1em]

	\textsc{\large Asesor}\\[1em]

	\textsc{\LARGE Dr. Andreas Wachtel}\\[2em]

	\end{center}

	\vspace*{\fill}
	\textsc{Ciudad de México \hspace*{\fill} \@date}
	\newpage
}

\newcommand{\makefrontmatter}{
	\pagestyle{empty}
	\noindent

	\noindent Typeset in Baskervald X and Nimbus Sans by
	\LaTeX.

	% \noindent This version is revision \gitAbbrevHash{} (\gitAuthorDate), with content generated

	\vfill
}
